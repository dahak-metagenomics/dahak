#!/bin/bash

#### From ubuntu 16.04 
sudo apt-get -y update && \
sudo apt-get -y install python-pip \
    zlib1g-dev ncurses-dev python-dev

#### Now, install the open science framework [command-line client](http://osfclient.readthedocs.io/en/stable/)
pip install osfclient

#### Sign back in and retrieve containers for quality assessment
docker pull biocontainers/fastqc
docker pull quay.io/biocontainers/trimmomatic:0.36--4
docker pull quay.io/biocontainers/khmer:2.1--py35_0
docker pull quay.io/biocontainers/pandaseq:2.11--1

#### Make a directory called data and retrieve some data using the osfclient. Specify the path to files.txt or move it to your working directory.  
mkdir ~/data
cd ~/data

for i in $(cat files.txt)
do 
        osf -p dm938 fetch osfstorage/data/${i}
done
d
#### Link the data and run [fastqc](https://www.bioinformatics.babraham.ac.uk/projects/fastqc/) 
mkdir ~/data/qc
mkdir ~/data/qc/before_trim30

for i in *.fq.gz
do
        docker run -v /home/ubuntu/data:/data -it biocontainers/fastqc fastqc ${i} -o /data/qc/before_trim30
done

#### Grab the adapter sequences
cd ~/data
curl -O -L http://dib-training.ucdavis.edu.s3.amazonaws.com/mRNAseq-semi-2015-03-04/TruSeq2-PE.fa

#### Link the data and run [trimmomatic](http://www.usadellab.org/cms/?page=trimmomatic)
for filename in *_1.fq.gz
do
  # first, make the base by removing .fq.gz using the unix program basename
  base=$(basename $filename .fq.gz)
  echo $base

 # now, construct the base2 filename by replacing _1 with _2
  base2=${base/_1/_2}
  echo $base2
  
  docker run -v /home/ubuntu/data:/data -it quay.io/biocontainers/trimmomatic:0.36--4 trimmomatic PE /data/${base}.fq.gz \
                /data/${base2}.fq.gz \
        /data/${base}.trim30.fq.gz /data/${base}_30se \
        /data/${base2}.trim30.fq.gz /data/${base2}_30se \
        ILLUMINACLIP:/data/TruSeq2-PE.fa:2:40:15 \
        LEADING:30 TRAILING:30 \
        SLIDINGWINDOW:4:30 \
        MINLEN:25
done

#### Now run fastqc on the trimmed data

mkdir ~/data/qc/after_trim30

for i in *.trim30.fq.gz
do
        docker run -v /home/ubuntu/data:/data -it biocontainers/fastqc fastqc ${i} -o /data/qc/after_trim30
done

#### Interleave paired-end reads using [khmer](http://khmer.readthedocs.io/en/v2.1.1/). The output file name includes 'trim30' indicating the reads were trimmed at a quality score of 30. If other values were used change the output name accordingly

cd ~/data
for filename in *_1.trim30.fq.gz
do
  # first, make the base by removing _1.trim.fq.gz with basename
  base=$(basename $filename _1.trim30.fq.gz)
  echo $base
  
  # construct the output filename
  output=${base}.pe.trim30.fq.gz
  
  docker run -v /home/ubuntu/data:/data -it quay.io/biocontainers/khmer:2.1--py35_0 interleave-reads.py \
        /data/${base}_1.trim30.fq.gz /data/${base}_2.trim30.fq.gz --no-reformat -o /data/$output --gzip

done

for i in ~/data/qc/*_trim30
do

        base=`echo ${i} | awk -F'[/]' '{print $6}'`
        echo $base

        docker run -v /home/ubuntu/data:/data -it quay.io/biocontainers/multiqc:1.2--py27_0 multiqc /data/qc/${base} -o /data/qc/${base}
done

