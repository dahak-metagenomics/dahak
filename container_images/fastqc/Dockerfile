FROM continuumio/miniconda
MAINTAINER cmreid@ucdavis.edu

RUN conda config --add channels defaults \
    && conda config --add channels conda-forge \
    && conda config --add channels bioconda \
    && conda install -y openjdk >8.0.121 fastqc=0.11.7

