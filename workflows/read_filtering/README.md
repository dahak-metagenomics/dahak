#### from ubuntu 16.04 
```
sudo apt-get -y update && \
sudo apt-get -y install python-pip \
    zlib1g-dev ncurses-dev python-dev
pip install osfclient
```

#### Install docker
```
wget -qO- https://get.docker.com/ | sudo sh
sudo usermod -aG docker ubuntu
exit
```

#### Sign back in and retrieve containers for quality assement
```
docker pull biocontainers/fastqc
quay.io/biocontainers/trimmomatic:0.36--4
docker pull quay.io/biocontainers/khmer:2.1--py35_0
docker pull biocontainers/jupyter
```

#### make a directory called data, download the osf cli, and retrieve some data
```
mkdir data
cd data
osf -p dm938 fetch osfstorage/SRR606249_subset10_1.fq.gz
osf -p dm938 fetch osfstorage/SRR606249_subset10_2.fq.gz
```

#### link the data and run fastqc 
```
mkdir qc
mkdir qc/before_trim 
cd qc/before_trim 
```
```
docker run -v /home/ubuntu/data:/data -it biocontainers/fastqc fastqc /data/SRR606249_subset10_1.fq.gz -o qc/before_trim
```
```
docker run -v /home/ubuntu/data:/data -it biocontainers/fastqc fastqc /data/SRR606249_subset10_2.fq.gz -o qc/before_trim
```

#### Grab the adapter sequences
```
cd ~/data
curl -O -L http://dib-training.ucdavis.edu.s3.amazonaws.com/mRNAseq-semi-2015-03-04/TruSeq2-PE.fa
```

#### link the data and run trimmomatic
```
docker run -v /home/ubuntu/data:/data -it quay.io/biocontainers/trimmomatic:0.36--4 trimmomatic PE /data/SRR606249_subset10_1.fq.gz \
                 /data/SRR606249_subset10_2.fq.gz \
        /data/SRR606249_subset10_1.trim.fq.gz /data/s1_se \
        /data/SRR606249_subset10_2.trim.fq.gz /data/s2_se \
        ILLUMINACLIP:/data/TruSeq2-PE.fa:2:40:15 \
        LEADING:2 TRAILING:2 \
        SLIDINGWINDOW:4:2 \
        MINLEN:25
```

#### Now run fastqc on the trimmed data
```
mkdir ~/data/qc/after_trim
cd qc/after_trim
```
```
docker run -v /home/ubuntu/data:/data -it biocontainers/fastqc fastqc /data/SRR606249_subset10_1.trim.fq.gz -o qc/after_trim
```
```
docker run -v /home/ubuntu/data:/data -it biocontainers/fastqc fastqc /data/SRR606249_subset10_2.trim.fq.gz -o qc/after_trim
```

#### Merge paired-end reads
```
cd ../..
docker run -v /home/ubuntu/data:/data -it quay.io/biocontainers/khmer:2.1--py35_0 interleave-reads.py /data/SRR606249_subset10_1.trim.fq.gz /data/SRR606249_subset10_2.trim.fq.gz --no-reformat -o /data/SRR606249_subset10.pe.trim.fq.gz --gzip
```
