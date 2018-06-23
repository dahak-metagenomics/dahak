# Installation Instructions

Before getting started with Dahak, you will need the following software installed:

**REQUIRED:**

* Docker or Singularity
* Python 3
* Conda
* Snakemake

The instructions below will help you get started running the software above.

<br />
<br />

# Installing Docker/Singularity

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

<br />
<br />

# Installing Python 

[Snakemake](http://snakemake.readthedocs.io/en/stable/) is a python build tool.

To ensure a universal installation process, we will use [pyenv](https://github.com/pyenv/pyenv)
to install the correct versions of Python and Conda.

There are many versions of Python, so your setup may vary.
We provide installation instructions using two methods:

* Aptitude-installed Python (requires root)
* Pyenv-managed Python (non-root)

Pyenv is a command-line tool for managing multiple
Python versions, including Conda.

## Installing Aptitude Python

To install Python with Aptitude:

```
sudo apt-get -y update
sudo apt-get -y install python-pip python-dev
```

## (Optional) Installing Pyenv

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

You should see a path with a `.pyenv` directory in it when you type 
`which pyenv`.

You can now install various Python versions (we will
install a version of Conda below):

```
PYVERSION="3.6.5"
PYVERSION="anaconda3-5.1.0"
PYVERSION="miniconda3-4.3.30"
```

To install it:

```
pyenv install $PYVERSION
```

To make it available on the `$PATH` (to make it the
version of Python that `python` on the command line
points to):

```
pyenv global $PYVERSION
eval "$(pyenv init -)"
```

To make this change permanent, you can add the
pyenv init statement to your `~/.bash_profile`:

```
echo 'eval "$(pyenv init -)"' >> ~/.bash_profile
source ~/.bash_profile
```

You should also have a version of `pip` associated
with `python`:

```
pip install --upgrade pip
```

<br />
<br />

# Installing Conda

Now we set the version of conda we wish to install. We will install
Miniconda 4.3.30 with Python 3:

```
CONDA="miniconda3-4.3.30"
pyenv install $CONDA
pyenv global $CONDA
eval "$(pyenv init -)"
```

You can also add this to your bash profile to ensure that the 
global pyenv Python version is always the first version of Python
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

<br />
<br />

# Installing Snakemake

Now install snakemake from the bioconda channel,
or install it using pip:

```
conda install -c bioconda snakemake
```

or

```
pip install snakemake
```

Note that this pip will correspond to the version of
Python and Conda that are on the path.

Finally, install the Open Science Framework CLI client
using pip:

```
pip install --user osfclient
```

