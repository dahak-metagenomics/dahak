# Read Filtering Walkthrough

The following walkthrough covers the steps in the read filtering and quality
assessment workflow. 

This workflow covers the use of Docker to interactively run the workflow on a
fresh Ubuntu 16.04 (Xenial) image, and requires sudo commands to be run.

The Snakefiles contained in this repository utilize Singularity containers
instead of Docker containers, but run analogous commands to those given in this
walkthrough.

This walkthrough presumes that the steps covered on the [Installing](installing.md)
page have been run, and that a version of Python, Conda, and Snakemake are available.
See the [Installing](installing.md) page for instructions on installing
required software.

### Walkthrough Steps

Starting with a fresh image, go through the installation instructions
on the [Installing](installing.md) page.

Install the open science framework [command-line client](http://osfclient.readthedocs.io/en/stable/):

```bash
pip install osfclient
```

Install [docker](https://www.docker.com) with the following shell commands:

```bash
wget -qO- https://get.docker.com/ | sudo sh
sudo usermod -aG docker ubuntu
exit
```

Make a directory called data and retrieve some data using the osfclient.
Specify the path to files.txt or move it to your working directory.  

```bash
mkdir data
cd data

for i in $(cat files.txt)
do 
    osf -p dm938 fetch osfstorage/data/${i}
done
```

Link the data and run [fastqc](https://www.bioinformatics.babraham.ac.uk/projects/fastqc/) 

```bash
mkdir -p ~/data/qc/before_trim

docker run -v ${PWD}:/data -it biocontainers/fastqc fastqc /data/SRR606249_subset10_1.fq.gz -o /data/qc/before_trim

docker run -v ${PWD}:/data -it biocontainers/fastqc fastqc /data/SRR606249_subset10_2.fq.gz -o /data/qc/before_trim
```

Grab the adapter sequences:

```bash
cd ~/data
curl -O -L http://dib-training.ucdavis.edu.s3.amazonaws.com/mRNAseq-semi-2015-03-04/TruSeq2-PE.fa
```

Link the data and run [trimmomatic](http://www.usadellab.org/cms/?page=trimmomatic)

```bash
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

Now run fastqc on the trimmed data:

```bash
mkdir -p ~/data/qc/after_trim


docker run -v ${PWD}:/data -it biocontainers/fastqc fastqc /data/SRR606249_subset10_1.trim.fq.gz -o /data/qc/after_trim

docker run -v ${PWD}:/data -it biocontainers/fastqc fastqc /data/SRR606249_subset10_2.trim.fq.gz -o /data/qc/after_trim
```

Interleave paired-end reads using [khmer](http://khmer.readthedocs.io/en/v2.1.1/). 
The output file name includes 'trim2' indicating the reads were trimmed at a quality score of 2. 
If other values were used change the output name accordingly.

```bash
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

