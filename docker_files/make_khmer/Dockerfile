# Use an official Python runtime as a base image
FROM ubuntu:16.04

# Set the maintaniner 
MAINTAINER ptbrooks@ucdavis.edu 

#
ENV PACKAGES python-pip samtools python-setuptools zlib1g-dev ncurses-dev python-dev python3.5-dev python3.5-venv make libc6-dev g++ zlib1g-dev

#
RUN apt-get update && \
    apt-get install -y --no-install-recommends ${PACKAGES} && \
    apt-get clean

# Set the working directory to /app
WORKDIR /home

# Install any needed packages specified in requirements.txt
RUN pip install khmer==2.1.1



