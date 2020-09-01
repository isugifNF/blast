# Running Blast in Parallel using Nextflow

This is a very simple example of a nextflow pipeline.

## Requirements

* Query sequence file (--query)
* blastn database Dir (--dbDir)
* blastn databse Name (--dbName)

## Optional
* Size of query input chunks you want to make (--chunkSize)
* Blast out filename (--outfileName)

## Test example

**Running on Laptop**

```
nextflow run parallelBLAST.nf --chunkSize 100 --dbDir "$PWD/testData/"
```

**Running on Condo or Ceres HPCC**

If you are running on condo, add `-profile condo` which will load any HPCC modules (e.g. `module load blast-plus` or `module load blast+`).

```
# For Condo
nextflow run parallelBLAST.nf --chunkSize 100 --dbDir "$PWD/testData/" -profile condo

# For Ceres
nextflow run parallelBLAST.nf --chunkSize 100 --dbDir "$PWD/testData/" -profile ceres
```

## Example
```
./nextflow run parallelBLAST.nf \
  --outdir newOUT \
  --dbDir "/work/GIF/severin/Purcell/Abalone/12_uniqueGenomicRegions/nextflowTest/out_dir" \
  --dbName blastdb \
  --outfileName newblastNameOut2 \
  --chunkSize 50
```


## Extending this example

* It is possible to modify the parallelBLAST.nf script by adding more to the blastn process in the script to generate more files.

### TODO
  * Done: Does not collate these files into `outdir`
  * Done: add functionality to run blastp, tblastn, tblastx, etc
  * add functionality to use diamond instead of blast
    * perhaps add an alias just for the run.
  * Add help and other info.

### GOTCHAs
  * Be sure to escape `$` ie `\$` in the awk statments or nextflow will complain
  * `-resume` not `--resume`

```
script:
    """
    blastn -num_threads=16 -db ${params.blastDB_DIR}/${params.blastDB_NAME} -query ${query} -outfmt ${params.blastOUTFMT} -out ${params.blastOUTFILE_NAME}
    awk 'BEGIN{ID="";count=0} (\$1!=ID) {print ID, count; count=0;ID=\$1} (\$1==ID){count++}' ${params.blastOUTFILE_NAME}  > blast.count
    awk 'BEGIN{ID="";count=0} (\$1!=ID) {print ID, count; count=0;ID=\$1} (\$1==ID){count++}' ${params.blastOUTFILE_NAME} | awk '\$2==1' > blastuniq.count
    """
```
