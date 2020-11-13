# isugifNF/blast

```
----------------------------------------------------
                                    \\---------//       
      ___  ___        _   ___  ___    \\-----//        
       |  (___  |  | / _   |   |_       \-//         
      _|_  ___) |__| \_/  _|_  |        // \        
                                      //-----\\       
                                    //---------\\       
      isugifNF/blast  v1.0.0       
    ----------------------------------------------------
```

[Genome Informatics Facility](https://gif.biotech.iastate.edu/) | [![Nextflow](https://img.shields.io/badge/nextflow-%E2%89%A519.10.0-brightgreen.svg)](https://www.nextflow.io/)

---

### Introduction

**isugifNF/blast** is a [nextflow pipeline](https://www.nextflow.io/) for [BLAST](https://blast.ncbi.nlm.nih.gov/Blast.cgi)-ing a fasta sequence file against a genome.

The workflow processes many sequences from a large fasta file `--query`, splits them into smaller fasta files, and parallel [BLAST](https://blast.ncbi.nlm.nih.gov/Blast.cgi) them against a given genome `--genome`. The pipeline can be run on a local laptop `-profile local` or on an HPCC cluster `-profile ceres` or `-profile condo`.

### Installation and running on Ceres HPCC

Nextflow is already installed on Ceres HPCC. Therefore, running **isugifNF/blast** involves (1) allocating a debug node `salloc -N 1 -p debug -t 01:00:00`, (2) loading nextflow `module load nextflow`, and (3) running the pipeline `nextflow run isugifNF/blast`. The `--help` flag prints out the usage statement.

```
salloc -N 1 -p debug -t 01:00:00
module load nextflow
nextflow run isugifNF/blast --help
```

<details><summary>see usage statement</summary>

```
Usage:
      The typical command for running the pipeline is as follows:
      nextflow run parallelBLAST.nf --query QUERY.fasta --genome GENOME.fasta -profile local
      nextflow run parallelBLAST.nf --query QUERY.fasta --dbDir "blastDatabaseDirectory" --dbName "blastPrefixName" -profile local

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
       --app                          BLAST program to use [blastn;blastp,tblastx,blastx]
       --help                         This usage statement.
```

</details>

### Dependencies if running locally

Nextflow is written in groovy which requires java version 1.8 or greater (check version using `java -version`). But otherwise can be installed if you have a working linux command-line.

```
java -version
curl -s https://get.nextflow.io | bash

# Check to see if nextflow is created
ls -ltr nextflow
#> total 32
#> -rwx--x--x  1 username  staff    15K Aug 12 12:47 nextflow
```

The pipeline **isugifNF/blast** can be run using singularity/docker containers or with a local [install of BLAST](https://ftp.ncbi.nlm.nih.gov/blast/executables/blast+/LATEST/). For a local install, select the appropriate installer if you are on windows (`*.exe`), linux (`*linux.tar.gz`), or MacOS (`*.dmg`). There are a few different ways to install BLAST locally, including brew, ports, and conda.

```
# test run using locally installed blast
nextflow run isugifNF/blast -profile test

# test run using containers (docker/singularity)
nextflow run isugifNF/blast -profile test,docker
nextflow run isugifNF/blast -profile test,singularity

# test run on Ceres HPC
nextflow run isugifNF/blast -profile test,ceres
```

Docker/singularity runs will take a few minutes since it needs to download the ncbi/blast container. Subsequent runs will be faster.

### Credits

These scripts were originally written for use on Ceres and Condo HPCC by Andrew Severin ([@isugif](https://github.com/isugif)), Siva Chudalayandi ([@Sivanandan](https://github.com/Sivanandan)), and Jennifer Chang ([@j23414](https://github.com/j23414))
