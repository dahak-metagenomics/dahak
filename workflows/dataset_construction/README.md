## Install the [SRA toolkit](https://www.ncbi.nlm.nih.gov/books/NBK158900/) from NCBI:
```
wget --output-document sratoolkit.tar.gz http://ftp-trace.ncbi.nlm.nih.gov/sra/sdk/current/sratoolkit.current-ubuntu64.tar.gz 
```
## Now extract the contents of the tar file:
```
tar -vxzf sratoolkit.tar.gz
```
## Note the name of the extracted tar file that will vary by name of the latest release you downloaded. It will start with "sratoolkit..."
```
ls
```
## In order for the new software to work we will have to put it in the VM's path. In the example the name of the sratoolkit is 
sratoolkit.2.8.2-1-ubuntu64. Make sure to get the dots and dashes correctly copied and don't forget to add /bin following the 
sratoolkit name.
```
export PATH=$PATH:$PWD/sratoolkit.2.8.2-1-ubuntu64/bin
```
## Use fastq dump to down the files
```
fastq-dump --split-files --gzip --defline-seq '@$ac.$si.$sg/$ri' --defline-qual '+' -Z SRR606249 > SRR606249.fq.gz
```
## Now we will use the sample-reads-randomly.py script from khmer to generate subsampled datasets with 10, 25, and 
50% percent of the reads.
```
sample-reads-randomly.py -N 10800000 -M 100000000 -o SRR606249_sub0.1.fq.gz --gzip
sample-reads-randomly.py -N 27000000 -M 100000000 -o SRR606249_sub0.25.fq.gz --gzip
sample-reads-randomly.py -N 54000000 -M 100000000 -o SRR606249_sub0.25.fq.gz --gzip
```
