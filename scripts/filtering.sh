#!bin/bash

i="SRR606249"

docker pull biocontainers/fastqc
docker pull quay.io/biocontainers/trimmomatic:0.36--4
docker pull quay.io/biocontainers/khmer:2.1--py35_0
docker pull quay.io/biocontainers/pandaseq:2.11--1

#mkdir data
#cd data
#osf -p dm938 fetch osfstorage/SRR606249_subset10_1.fq.gz
#osf -p dm938 fetch osfstorage/SRR606249_subset10_2.fq.gz

#### Link the data and run fastqc
mkdir qc
mkdir qc/before_trim 
cd qc/before_trim 

docker run -v /home/ubuntu/data:/data -it biocontainers/fastqc fastqc /data/$i_1.fq.gz -o /data/qc/before_trim
docker run -v /home/ubuntu/data:/data -it biocontainers/fastqc fastqc /data/$i_2.fq.gz -o /data/qc/before_trim

#### Download the adapters 
cd ~/data
curl -O -L http://dib-training.ucdavis.edu.s3.amazonaws.com/mRNAseq-semi-2015-03-04/TruSeq2-PE.fa

#### Run trimmomatic
docker run -v /home/ubuntu/data:/data -it quay.io/biocontainers/trimmomatic:0.36--4 trimmomatic PE /data/$i_1.fq.gz \
                 /data/$i_2.fq.gz \
        /data/$i_1.trim.fq.gz /data/s1_se \
        /data/$i_2.trim.fq.gz /data/s2_se \
        ILLUMINACLIP:/data/TruSeq2-PE.fa:2:40:15 \
        LEADING:2 TRAILING:2 \
        SLIDINGWINDOW:4:2 \
        MINLEN:25

#### Create a directory for the trimmed data and run fastqc again         
mkdir ~/data/qc/after_trim
cd qc/after_trim

docker run -v /home/ubuntu/data:/data -it biocontainers/fastqc fastqc /data/$i_1.trim.fq.gz -o /data/qc/after_trim
docker run -v /home/ubuntu/data:/data -it biocontainers/fastqc fastqc /data/$i_2.trim.fq.gz -o /data/qc/after_trim

#### Interleave the reads 
cd ~/data
docker run -v /home/ubuntu/data:/data -it quay.io/biocontainers/khmer:2.1--py35_0 interleave-reads.py /data/$i_1.trim.fq.gz /data/$i_2.trim.fq.gz --no-reformat -o /data/$i.pe.trim.fq.gz --gzip
