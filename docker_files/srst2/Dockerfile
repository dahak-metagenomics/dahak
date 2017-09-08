FROM ubuntu:16.04
MAINTAINER ptbrooks@ucdavis.edu

RUN apt-get -y update && \
apt-get install -y python2.7 make libc6-dev g++ zlib1g-dev build-essential git \
libx11-dev xutils-dev zlib1g-dev python-pip bowtie2 curl libncurses5-dev

RUN pip install -U pip
RUN curl -O -L https://sourceforge.net/projects/samtools/files/samtools/0.1.18/samtools-0.1.18.tar.bz2 && tar xvfj samtools-0.1.18.tar.bz2 && cd samtools-0.1.18 && make && cp samtools /usr/local/bin &&  cp bcftools/bcftools /usr/local/bin && cd misc/ &&  cp *.pl maq2sam-long maq2sam-short md5fa md5sum-lite wgsim /usr/local/bin/ && cd 
RUN pip install scipy 
RUN pip install git+https://github.com/katholt/srst2

