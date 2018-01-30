Read assessement and filtering
==============================

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

#### Install [docker](https://www.docker.com)
```
wget -qO- https://get.docker.com/ | sudo sh
sudo usermod -aG docker ubuntu
exit
```

#### Sign back in and make a directory called data and retrieve some data using the osfclient. Specify the path to files.txt or move it to your working directory.  
```
mkdir data
cd data

for i in $(cat files.txt)
do 
	osf -p dm938 fetch osfstorage/data/${i}
done
```

#### Link the data and run [fastqc](https://www.bioinformatics.babraham.ac.uk/projects/fastqc/) 
```
mkdir qc
mkdir qc/before_trim 
cd qc/before_trim 
```
```
docker run -v ${PWD}:/data -it biocontainers/fastqc fastqc /data/SRR606249_subset10_1.fq.gz -o /data/qc/before_trim
```
```
docker run -v ${PWD}:/data -it biocontainers/fastqc fastqc /data/SRR606249_subset10_2.fq.gz -o /data/qc/before_trim
```

#### Grab the adapter sequences
```
cd ~/data
curl -O -L http://dib-training.ucdavis.edu.s3.amazonaws.com/mRNAseq-semi-2015-03-04/TruSeq2-PE.fa
```

#### Link the data and run [trimmomatic](http://www.usadellab.org/cms/?page=trimmomatic)
```
for filename in *_1*.fq.gz
do
    # first, make the base by removing .fq.gz using the unix program basename
    base=$(basename $filename .fq.gz)
    echo $base

    # now, construct the base2 filename by replacing _1 with _2
    base2=${base/_1/_2}
    echo $base2

    docker run -v ${PWD}:/data -it quay.io/biocontainers/trimmomatic:0.36--4 trimmomatic PE /data/${base}.fq.gz \
                /data/${base2}.fq.gz \
        /data/${base}.trim.fq.gz /data/${base}_se \
        /data/${base2}.trim.fq.gz /data/${base2}_se \
        ILLUMINACLIP:/data/TruSeq2-PE.fa:2:40:15 \
        LEADING:2 TRAILING:2 \
        SLIDINGWINDOW:4:2 \
        MINLEN:25
done
```

#### Now run fastqc on the trimmed data
```
mkdir ~/data/qc/after_trim
cd qc/after_trim
```
```
docker run -v ${PWD}:/data -it biocontainers/fastqc fastqc /data/SRR606249_subset10_1.trim.fq.gz -o /data/qc/after_trim
```
```
docker run -v ${PWD}:/data -it biocontainers/fastqc fastqc /data/SRR606249_subset10_2.trim.fq.gz -o /data/qc/after_trim
```

#### Interleave paired-end reads using [khmer](http://khmer.readthedocs.io/en/v2.1.1/). The output file name includes 'trim2' indicating the reads were trimmed at a quality score of 2. If other values were used change the output name accordingly

```
cd ~/data
for filename in *_1.trim.fq.gz
do
    # first, make the base by removing _1.trim.fq.gz with basename
    base=$(basename $filename _1.trim.fq.gz)
    echo $base

    # construct the output filename
    output=${base}.pe.trim2.fq.gz

    docker run -v ${PWD}:/data -it quay.io/biocontainers/khmer:2.1--py35_0 interleave-reads.py \
        /data/${base}_1.trim.fq.gz /data/${base}_2.trim.fq.gz --no-reformat -o /data/$output --gzip

done
```
