# Getting started with Docker

If you want to run these protocols interactively you will need to install Docker on your system. You can find more detailed instructions [here](https://docs.docker.com/install/). Alternatively we've developed snakefiles for automation that do not require installation. You can find those instructions below. 

#### First, update your machine
```
sudo apt-get -y update && \
sudo apt-get -y install python-pip \
    zlib1g-dev ncurses-dev python-dev
```
#### Now, install the [open science framework command-line client](http://osfclient.readthedocs.io/en/stable/). We'll use this tool download data.
```
pip install osfclient
```
#### Finally, install [docker](https://www.docker.com)
```
wget -qO- https://get.docker.com/ | sudo sh
sudo usermod -aG docker ubuntu
exit
```

# Getting started with [Snakemake](http://snakemake.readthedocs.io/en/stable/) and [Singularity](http://singularity.lbl.gov) 

#### First, download miniconda or anaconda if you prefer. 
```
curl -L -O https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh
bash Miniconda3-latest-Linux-x86_64.sh
```
#### Next, set the channels (modify your path accordingly)
```
/home/ubuntu/miniconda3/bin/conda config --add channels r
/home/ubuntu/miniconda3/bin/conda config --add channels defaults
/home/ubuntu/miniconda3/bin/conda config --add channels conda-forge
/home/ubuntu/miniconda3/bin/conda config --add channels bioconda
```
#### Then, install bioconda and snakemake on your system. 
```
conda install -c bioconda snakemake
```
#### After logging back in, proceed to install singularity. These instructions are for Ubuntu 16.04. Take a look at their website for alternate/updated instructions. 
```
sudo wget -O- http://neuro.debian.net/lists/xenial.us-ca.full | sudo tee /etc/apt/sources.list.d/neurodebian.sources.list
```
sudo apt-key adv --recv-keys --keyserver hkp://pool.sks-keyservers.net:80 0xA5D32F012649A5A9
```
#### Update
```
sudo apt-get update 
```
#### Now install
```
sudo apt-get install -y singularity-container
```
#### You can check the version
```
singularity --version
```

