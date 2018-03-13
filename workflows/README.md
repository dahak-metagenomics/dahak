# Workflows and Workflow Components

When analyzing metagenomic data, different workflows
are broken down into atomic operations. Each directory here
corresponds to an atomic operation (a workflow component).

A flowchart illustrating how each workflow component fits 
together with tools into the overall process is included below:

<img width="500px" src="/resources/WorkflowFlowchartOriginal.png" />

Each workflow has its own Snakefile. The Snakefile is composed of a 
list of simple rules that specify how an input file is turned into 
an output file. 

The following workflows are required deliverables:
* Taxonomic characterization of bulk metagenome data sets with the sourmash tool against public and private reference databases;
* Assembly-based approaches to give higher-confidence gene identity assignment than raw read assignment alone;
* MinHash-based taxonomic description of data sets;
* Full-set and marker gene analysis of hybrid assembly/read collections to characterize taxonomic content;
* Full-set gene analysis of hybrid assembly/read collections to characterize functional content;
* Taxonomic and functional analysis performed on reads left out of the assembly;
* Rapid k-mer-based ordination analyses of many samples to provide sample groupings and identify potential outliers; and
* Interactive Jupyter notebooks for interpretation of results.

## Workflow Descriptions

For coverage of workflows, see [Workflows.md](/workflows/Workflows.md).

For coverage of workflow components, see [WorkflowComponents.md](/workflows/WorkflowComponents.md).

## Running Workflows

The shell commands for each workflow are documented in each subdirectory (for example, workflows for taxonomic characterization of bulk metagenome data sets is located in the [dahak/workflows/taxonomic_classification](https://github.com/dahak-metagenomics/dahak/tree/master/workflows/taxonomic_classification) folder).

Snakemake files for workflows are being assembled in the [dahak-flot](https://github.com/dahak-metagenomics/dahak-flot) repository, with the intention of porting them back to the dahak repository.

## Getting Started

The instructions that follow will help you get started running the workflows
described above. 

### Getting Started with Docker

If you want to run these protocols interactively you will need to install Docker on your system. You can find more detailed instructions [here](https://docs.docker.com/install/). 
Alternatively we've developed snakefiles for automation that do not require installation. You can find those instructions below. 

First, update your machine:

```
# Update aptitude and install dependencies
sudo apt-get -y update

sudo apt-get -y install zlib1g-dev
sudo apt-get -y install ncurses-dev
```

Next, install Docker:

```
# Install Docker
wget -qO- https://get.docker.com/ | sudo sh
sudo usermod -aG docker ubuntu
```

### Getting Started with Singularity

[Singularity](http://singularity.lbl.gov) is a tool for running Docker containers 
in higher security environments where permissions are restricted.

After logging back in, proceed to install singularity. These instructions are for Ubuntu 16.04. Take a look at their website for alternate/updated instructions. 

```
wget -O- http://neuro.debian.net/lists/xenial.us-ca.full | tee /etc/apt/sources.list.d/neurodebian.sources.list
apt-key adv --recv-keys --keyserver hkp://pool.sks-keyservers.net:80 0xA5D32F012649A5A9
```

Update aptitude's information about the new software repositories:

```
sudo apt-get update
```

Now install singularity:

```
sudo apt-get install -y singularity-container
```

Once it is installed, you can check the version:

```
singularity --version
```

### Getting Started with Snakemake

[Snakemake](http://snakemake.readthedocs.io/en/stable/) is a python build tool.
To ensure a universal installation process, we will use [pyenv](https://github.com/pyenv/pyenv)
to install the correct versions of python and conda.

Start by running the pyenv installer:

```
# Install pyenv 
curl -L https://raw.githubusercontent.com/pyenv/pyenv-installer/master/bin/pyenv-installer | bash
```

Add pyenv's bin directory to `$PATH` (should already be in `~/.bash_profile` but just in case):

```
echo 'export PATH="~/.pyenv/bin:$PATH"' >> ~/.bash_profile
```

Now we set the version of conda we wish to install. We will install
miniconda 4.3.30 for python 3:

```
CONDA="miniconda3-4.3.30"
pyenv install $CONDA
pyenv global $CONDA
eval "$(pyenv init -)"
```

Now you can check to make sure you have the pyenv-installed version 
of conda:

```
which conda
conda --version
python --version
```

Add the required conda channels:

```
conda update
conda config --add channels r
conda config --add channels defaults
conda config --add channels conda-forge
conda config --add channels bioconda
```

Now install snakemake from the bioconda channel:

```
conda install -c bioconda snakemake
```

Finally, install the Open Science Framework CLI client
using pip (this pip will correspond to the same python 
that the conda and python commands point to):

```
pip install --upgrade pip
pip install --user osfclient
```
