#### From ubuntu 16.04 
```
sudo apt-get -y update && \
sudo apt-get -y install python-pip \
    zlib1g-dev ncurses-dev python-dev
```
#### Now, install the open science framework [command-line client](http://osfclient.readthedocs.io/en/stable/)
```
pip install osfclient
```

#### Sign back in and retrieve containers for quality assessment
```
docker pull biocontainers/fastqc
docker pull quay.io/biocontainers/trimmomatic:0.36--4
docker pull quay.io/biocontainers/khmer:2.1--py35_0
docker pull quay.io/biocontainers/pandaseq:2.11--1
```

#### Make a directory called data and retrieve some data using the osfclient. Specify the path to files.txt or move it to your working directory.  
```
mkdir ~/data
cd ~/data

for i in $(cat ~/files.txt)
do 
        osf -p dm938 fetch osfstorage/data/${i}
done
```

#### Link the data and run [fastqc](https://www.bioinformatics.babraham.ac.uk/projects/fastqc/) 
```
mkdir ~/data/qc
mkdir ~/data/qc/before_trim 
cd ~/data/qc/before_trim 
```
for i in ~/data/*.fq.gz
do
        docker run -v /home/ubuntu/data:/data -it biocontainers/fastqc fastqc /data/${i} -o /data/qc/before_trim
done
```

#### Grab the adapter sequences
```
cd ~/data
curl -O -L http://dib-training.ucdavis.edu.s3.amazonaws.com/mRNAseq-semi-2015-03-04/TruSeq2-PE.fa
```
#### Link the data and run [trimmomatic](http://www.usadellab.org/cms/?page=trimmomatic)
```
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
        /data/${base}.trim30.fq.gz /data/${base}_se \
        /data/${base2}.trim30.fq.gz /data/${base2}_se \
        ILLUMINACLIP:/data/TruSeq2-PE.fa:2:40:15 \
        LEADING:30 TRAILING:30 \
        SLIDINGWINDOW:4:30 \
        MINLEN:25
done
```

#### Now run fastqc on the trimmed data
```
mkdir ~/data/qc/after_trim
cd ~/data/qc/after_trim
```
```

for i in ~/data/*.trim30.fq.gz
do
        docker run -v /home/ubuntu/data:/data -it biocontainers/fastqc fastqc /data/${i} -o /data/qc/after_trim
done
```

#### Interleave paired-end reads using [khmer](http://khmer.readthedocs.io/en/v2.1.1/). The output file name includes 'trim2' indicating the reads were trimmed at a quality score of 2. If other values were used change the output name accordingly

```
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
```
