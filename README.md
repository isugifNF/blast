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

Nextflow is already installed on Ceres HPCC. Therefore, running **isugifNF/blast** involes (1) allocating a debug node `salloc -N 1 -p debug -t 01:00:00`, (2) loading nextflow `module load nextflow`, and (3) running the pipeline `nextflow run isugifNF/blast`. The `--help` flag prints out the usage sstatement.

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
nextflow run isugifNF/blast -profile temp

# test run using containers (docker/singularity)
nextflow run isugifNF/blast -profile test,docker
nextflow run isugifNF/blast -profile test,singularity
```

Docker/singularity runs will take a few minutes since it needs to download the ncbi/blast container. Subsequent runs will be faster.

### Credits

These scripts were originally written for use on Ceres and Condo HPCC by Andrew Severin ([@isugif](https://github.com/isugif)), Siva Chudalayandi ([@Sivanandan](https://github.com/Sivanandan)), and Jennifer Chang ([@j23414](https://github.com/j23414))


<!-- 

### Scrap past this

### Dependencies

<details><summary>Java v1.8 or greater</summary>

```
java -version
```

</details>

<details><summary>NextFlow</summary>

```
# Fetch and run install script
curl -s https://get.nextflow.io | bash
ls -ltr nextflow
```

</details>

<details><summary>NCBI-toolkit</summary>



</details>

* Requires 

To run **isugifNF/blast**, you will need to have nextflow installed or available. The most up-to-date instructions for installing nextflow will be at [nextflow.io](https://www.nextflow.io/).

```
# Needs java version 1.8 or greater
java -version            

# Fetch and run install script
curl -s https://get.nextflow.io | bash
ls -ltr nextflow

# Check if nextflow is working
./nextflow run hello
```

### Install and run pipeline

```
nextflow run isugifNF/blast --help
```

<details><summary>Install Nextflow on Linux</summary>

```
java -version
curl -s https://get.nextflow.io | bash
ls -ltr nextflow
./nextflow run hello
```

</details>

<details><summary>Install Nextflow on MacOS</summary>

* [Install XCode from Mac App Store]()
* [Install Java (v1.8 or greater) for MacOS](https://java.com/en/download/mac_download.jsp)
* Open Go/Utilities/Terminal

```
java -version
curl -s https://get.nextflow.io | bash
ls -ltr nextflow
./nextflow run hello
```

<details>

<details><summary>Use Nextflow on Ceres HPCC</summary>

```
load module nextflow
nextflow 
```

</details>


<details><summary>Install nextflow locally</summary>

Most up-to-date instructions for installing nextflow will be at nextflow.io. Nextflow depends on Java 1.8 or greater `java --version`.


```
# Check that java is version 1.8 or greater
java --version
java version "1.8.0_162"
Java(TM) SE Runtime Environment (build 1.8.0_162-b12)
Java HotSpot(TM) 64-Bit Server VM (build 25.162-b12, mixed mode)
```

Then we can fetch the nextflow install script `curl -s https://get.nextflow.io` and run it in `bash`:

```
# Install nextflow to current directory
curl -s https://get.nextflow.io | bash

      N E X T F L O W
      version 20.07.1 build 5412
      created 24-07-2020 15:18 UTC (10:18 CDT)
      cite doi:10.1038/nbt.3820
      http://nextflow.io


Nextflow installation completed. Please note:
- the executable file `nextflow` has been created in the folder: /Users/jenchang/Desktop/temp
- you may complete the installation by moving it to a directory in your $PATH

```

By the end you can list `ls` the nextflow file in current folder:

```
ls -ltr nextflow
#> total 32
#> -rwx--x--x  1 jenchang  staff    15K Aug 12 12:47 nextflow
```

</details>

# To run on Ceres HPCC

For those on ceres HPCC, nextflow is already installed in a module. Ergo you can run the blast pipeline with the following:

```
salloc -N 1 -p debug -t 01:00:00.      # get a debug node
module load nextflow                   # nextflow on ceres
nextflow run isugifNF/blast --help     # should return instructions
```

To run the pipeline, you must have at least a query and a genome.

```
# run on ceres
nextflow run isugifNF/blast -profile ceres \
  --query query.fasta \
  --genome genome.fasta

ls -ltr out_dir                        # to see output blast results
```
-->

