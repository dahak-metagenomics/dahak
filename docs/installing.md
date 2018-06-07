# Installation Instructions

Before getting started with dahak, you will need the following software installed:

**REQUIRED:**

* Docker or Singularity
* Python 3
* Snakemake
* Conda

The instructions below will help you get started running the software above.


## Getting Started with Singularity

[Singularity](http://singularity.lbl.gov) is a tool for running Docker
containers in higher security environments (e.g., high performance computing
clusters) where permissions are restricted. If you wish to use Docker directly
and have root access (e.g., with AWS/cloud machines), see the "Getting Started
with Docker" section below.

Installing a stable version of Singularity is recommended. Stable versions can
be obtained from [Singularity's Releases on
Github](https://github.com/singularityware/singularity/releases).

(In an HPC environment, these commands are run by the system administrator.)

```
# Latest
VERSION=2.5.1

# More widely available
VERSION=2.4.6

wget https://github.com/singularityware/singularity/releases/download/$VERSION/singularity-$VERSION.tar.gz
tar xvf singularity-$VERSION.tar.gz
cd singularity-$VERSION
./configure --prefix=/usr/local
make
sudo make install
```

To check whether Singularity is installed (in an HPC environment, this command
is run by the user), check the version:

```
singularity --version
```


## (Optional) Getting Started with Docker

If you wish to follow along with the walkthroughs, which cover the use of
Docker containers to run the workflows interactively, you will need to install
Docker, which requires root access.

Alternatively, Dahak provides Snakefiles for automating these workflows without
requiring root access by using Singularity (see instructions above). 

First, update your machine:

```
# Update aptitude and install dependencies
sudo apt-get -y update && sudo apt-get install zlib1g-dev ncurses-dev
```

Next, install Docker:

```
# Install Docker
wget -qO- https://get.docker.com/ | sudo sh
sudo usermod -aG docker ubuntu
```



## Installing Python, Conda, and Snakemake

[Snakemake](http://snakemake.readthedocs.io/en/stable/) is a python build tool.

To ensure a universal installation process, we will use [pyenv](https://github.com/pyenv/pyenv)
to install the correct versions of Python and Conda.

### Installing Pyenv

Start by running the pyenv installer:

```
# Install pyenv 
curl -L https://raw.githubusercontent.com/pyenv/pyenv-installer/master/bin/pyenv-installer | bash
```

Add pyenv's bin directory to `$PATH` (should already be in `~/.bash_profile` but just in case):

```
echo 'export PATH="~/.pyenv/bin:$PATH"' >> ~/.bash_profile
source ~/.bash_profile
```

You should see a path to a Python in a `.pyenv` directory when you type `which
python`.


### Installing Conda

Now we set the version of conda we wish to install. We will install
Miniconda 4.3.30 with Python 3:

```
CONDA="miniconda3-4.3.30"
pyenv install $CONDA
pyenv global $CONDA
eval "$(pyenv init -)"
```

You can also add this to your bash profile to ensure that the 
global Pyenv Python version is always the first version of Python
on your path:

```
echo 'eval "$(pyenv init -)"' >> ~/.bash_profile
source ~/.bash_profile
``` 

Now check to make sure you have the pyenv-installed version of conda: 

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

### Installing Snakemake

Now install snakemake from the bioconda channel:

```
conda install -c bioconda snakemake

# or

pip install snakemake
```

Finally, install the Open Science Framework CLI client
using pip (this pip will correspond to the same python 
that the conda and python commands point to):

```
pip install --upgrade pip
pip install --user osfclient
```

