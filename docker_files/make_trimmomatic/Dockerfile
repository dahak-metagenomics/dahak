FROM ubuntu:16.04

# Set the maintaniner 
MAINTAINER ptbrooks@ucdavis.edu 

#
ENV PACKAGES wget unzip libjbzip2-java libsam-java fastx-toolkit

#
RUN apt-get update && \
    apt-get install -y --no-install-recommends ${PACKAGES} && \
    apt-get clean 

WORKDIR /home

RUN wget -c http://www.bioinformatics.babraham.ac.uk/projects/fastqc/fastqc_v0.11.5.zip && \
	unzip fastqc_v0.11.5.zip && \
	cd FastQC && \
	chmod +x fastqc && \
	ln -s /home/FastQC/fastqc /usr/local/bin/fastqc

