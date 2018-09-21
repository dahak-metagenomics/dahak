# Instantiate Docker container from ubuntu image
FROM ubuntu:16.04

# Set the maintainer
MAINTAINER Phil Brooks, ptbrooks@ucdavis.edu

#Define dependencies
ENV PACKAGES g++ make git zlib1g-dev python

#Update and install packages
RUN apt-get update && \
    apt-get install -y ${PACKAGES} && \
    apt-get clean

#Install MEGAHIT
RUN git clone https://github.com/voutcn/megahit.git /home/megahit
RUN make --directory=/home/megahit
