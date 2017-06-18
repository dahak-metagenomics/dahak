Make directory for dockerfile 

```
# Use an official Python runtime as a base image
FROM ubuntu:16.04

# Set the maintaniner
MAINTAINER ptbrooks@ucdavis.edu

#
ENV PACKAGES python-pip samtools python-setuptools zlib1g-dev ncurses-dev python-dev python3.5-dev python3.5-venv make libc6-$

#
RUN apt-get update && \
    apt-get install -y --no-install-recommends ${PACKAGES} && \
    apt-get clean

# Set the working directory to /app
WORKDIR /home

# Install any needed packages specified in requirements.txt
RUN pip install khmer==2.1.1
```
	
Make docker file 
```
nano Dockerfile
```
Check it out 
```
cat Dockerfile
```

Build docker image 
```
docker build -t khmer_ctr .
```
Test it 
```
docker run -it khmer_ctr load-into-counting.py --version 
```


