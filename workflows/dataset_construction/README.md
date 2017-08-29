#### Install the [SRA toolkit](https://www.ncbi.nlm.nih.gov/books/NBK158900/) from NCBI:
```
wget --output-document sratoolkit.tar.gz http://ftp-trace.ncbi.nlm.nih.gov/sra/sdk/current/sratoolkit.current-ubuntu64.tar.gz 
```
#### Now extract the contents of the tar file:
```
tar -vxzf sratoolkit.tar.gz
```
#### Note the name of the extracted tar file that will vary by name of the latest release you downloaded. It will start with "sratoolkit..."
```
ls
```
#### In order for the new software to work we will have to put it in our path. In the example the name of the sratoolkit is sratoolkit.2.8.2-1-ubuntu64.
```
export PATH=$PATH:$PWD/sratoolkit.2.8.2-1-ubuntu64/bin
```
#### Next, install khmer
```
pip install khmer 
```
#### Use [fastq-dump](https://edwards.sdsu.edu/research/fastq-dump/) to download the files
```
fastq-dump --split-files --gzip --defline-seq '@$ac.$si.$sg/$ri' --defline-qual '+' -Z SRR606249 > SRR606249.fq.gz
```
#### Now we will use the sample-reads-randomly.py script from khmer to generate subsampled datasets with 10, 25, and 50% percent of the reads.
```
sample-reads-randomly.py -N 10800000 -M 100000000 -o SRR606249_subset10.fq.gz --gzip SRR606249.fq.gz
sample-reads-randomly.py -N 27000000 -M 100000000 -o SRR606249_subset25.fq.gz --gzip SRR606249.fq.gz
sample-reads-randomly.py -N 54000000 -M 100000000 -o SRR606249_subset50.fq.gz --gzip SRR606249.fq.gz
```
#### Split the reads prior to uploading for storage
```
split-paired-reads.py SRR606249_subset10.fq.gz -1 SRR606249_subset10_1.fq.gz -2 SRR606249_subset10_2.fq.gz --gzip 
split-paired-reads.py SRR606249_subset25.fq.gz -1 SRR606249_subset25_1.fq.gz -2 SRR606249_subset25_2.fq.gz --gzip 
split-paired-reads.py SRR606249_subset50.fq.gz -1 SRR606249_subset50_1.fq.gz -2 SRR606249_subset50_2.fq.gz --gzip 
```

