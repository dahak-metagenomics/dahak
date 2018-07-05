FROM ubuntu:16.04
RUN apt-get -y update && apt-get install -y python2.7 make     libc6-dev g++ zlib1g-dev build-essential git libx11-dev xutils-dev zlib1g-dev python-pip bowtie2 samtools
RUN pip install -U pip
RUN pip install scipy 
RUN pip install git+https://github.com/katholt/srst2
