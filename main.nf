#! /usr/bin/env nextflow

/*************************************
 Parallel BLAST
 *************************************/


 def helpMessage() {
     log.info isuGIFHeader()
     log.info """
      Usage:
      The typical command for running the pipeline is as follows:
      nextflow run main.nf --query QUERY.fasta --genome GENOME.fasta -profile local
      nextflow run main.nf --query QUERY.fasta --dbDir "blastDatabaseDirectory" --dbName "blastPrefixName" -profile local

      Mandatory arguments:
       --query                        Query fasta file of sequences you wish to BLAST
       --genome                       Genome from which BLAST databases will be generated
       or
       --query                        Query fasta file of sequences you wish to BLAST
       --dbDir                        BLAST database directory (full path required)
       --dbName                       Prefix name of the BLAST database
       -profile                       Configuration profile to use. Can use multiple (comma separated)
                                      Available: test, condo, ceres, local, nova

       Optional arguments:
       --outdir                       Output directory to place final BLAST output
       --outfmt                       Output format ['6 qseqid sseqid pident length mismatch gapopen qstart qend sstart send evalue bitscore qlen slen frames salltitles qcovs']
       --options                      Additional options for BLAST command [-evalue 1e-3]
       --outfileName                  Prefix name for BLAST output [blastout]
       --threads                      Number of CPUs to use during blast job [16]
       --chunkSize                    Number of fasta records to use when splitting the query fasta file
       --app                          BLAST program to use [blastn;blastp,tblastn,blastx]
       --queueSize                    Maximum number of jobs to be queued [18]
       --help                         This usage statement.
     """
 }



 // Show help message
 if (params.help) {
     helpMessage()
     exit 0
 }


Channel
    .fromPath(params.query)
    .splitFasta(by: params.chunkSize, file:true) // this is how you can split a fasta using nextflow's method
    .set { Query_chunks }

process software_check {
  label 'software_check'

  publishDir params.outdir

  output:
    path 'software_check.txt'

  script:
  """
  echo "blastn -version" > software_check.txt
  blastn -version >> software_check.txt

  echo "\nmakeblastdb -version" >> software_check.txt
  makeblastdb -version >> software_check.txt

  """
}



if (params.genome) {

  genomefile = Channel
                .fromPath(params.genome)
                .map { file -> tuple(file.simpleName, file.parent, file) } //requires the file part of this tuple for some reason even though I don't use it downstream

  process runMakeBlastDB {
    label 'blast'

  //  publishDir "${params.outdir}", mode: 'copy', pattern: '$name'

    input:
    set val(name), path(dbDir), file(FILE) from genomefile

    output:
    // val params.genome.take(params.genome.lastIndexOf('.')) into dbName_ch
    val name into dbName_ch
    path dbDir into dbDir_ch

    script:
    """
    makeblastdb -in ${params.genome} -dbtype 'nucl' -out $dbDir/$name
    # makeblastdb -in ${params.genome} -dbtype 'prot' -out $dbDir/$name

    """

    }
} else {
  dbName_ch = Channel.from(params.dbName)
  dbDir_ch = Channel.fromPath(params.dbDir)
}

process runBlast {
  label 'blast'

  input:
  path query from Query_chunks
//  val flag from done_ch
path dbDir from dbDir_ch.val
val dbName from dbName_ch.val

  output:
  path params.outfileName into blast_output

  script:
  """
  echo "${params.app}  -num_threads ${params.threads} -db $dbDir/$dbName -query $query -outfmt $params.outfmt $params.options -out $params.outfileName" > blast.log
  ${params.app}  -num_threads ${params.threads} -db $dbDir/$dbName -query $query -outfmt $params.outfmt $params.options -out $params.outfileName

  """

}

blast_output  // this is the channel that you want to collect files; this can also be Channel.from('filename')
    .collectFile(name: 'blast_output_combined.txt', storeDir: params.outdir) // this is the command to do the collection into the file named with name: and the directory with storeDir:
    .subscribe { // subscribe apparently gives you a way to print info to stdout during this process.
        println "Entries are saved to file: $it"
    }


    def isuGIFHeader() {
        // Log colors ANSI codes
        c_reset = params.monochrome_logs ? '' : "\033[0m";
        c_dim = params.monochrome_logs ? '' : "\033[2m";
        c_black = params.monochrome_logs ? '' : "\033[1;90m";
        c_green = params.monochrome_logs ? '' : "\033[1;92m";
        c_yellow = params.monochrome_logs ? '' : "\033[1;93m";
        c_blue = params.monochrome_logs ? '' : "\033[1;94m";
        c_purple = params.monochrome_logs ? '' : "\033[1;95m";
        c_cyan = params.monochrome_logs ? '' : "\033[1;96m";
        c_white = params.monochrome_logs ? '' : "\033[1;97m";
        c_red = params.monochrome_logs ? '' :  "\033[1;91m";

        return """    -${c_dim}--------------------------------------------------${c_reset}-
        ${c_white}                                ${c_red   }\\\\------${c_yellow}---//       ${c_reset}
        ${c_white}  ___  ___        _   ___  ___  ${c_red   }  \\\\---${c_yellow}--//        ${c_reset}
        ${c_white}   |  (___  |  | / _   |   |_   ${c_red   }    \\-${c_yellow}//         ${c_reset}
        ${c_white}  _|_  ___) |__| \\_/  _|_  |    ${c_red  }    ${c_yellow}//${c_red  } \\        ${c_reset}
        ${c_white}                                ${c_red   }  ${c_yellow}//---${c_red  }--\\\\       ${c_reset}
        ${c_white}                                ${c_red   }${c_yellow}//------${c_red  }---\\\\       ${c_reset}
        ${c_cyan}  isugifNF/blast  v${workflow.manifest.version}       ${c_reset}
        -${c_dim}--------------------------------------------------${c_reset}-
        """.stripIndent()
    }
