This directory contains recipes for building local, custom container images for
both Singularity and Docker.

# Motivation

The Dahak workflows are intended to be used with software from the bioconda
project. Specifically, by default software is obtained by pulling containers
from quay.io biocontainers. In an ideal world this approach would always work.

In practice, it is useful to be able to use custom container images, in case
biocontainers are broken, or if a custom software build should be used for
particular steps in a pipeline. (Note that this is for custom builds only, if
all you want to do is compare the output of two versions of a given piece of
software, quay.io biocontainers can be obtained for multiple versions and
should be sufficient for that task.)

# Using Custom Containers

Using a custom container is a two-step process:

* Step 1: Build the container locally
* Step 2: Specify in the Snakemake configuration file that Singularity should
  use a local image, and specify the name of the container image to use.

## Step 1: Build the Custom Container Locally

To build a container locally, you need a recipe file.  If you are using Docker,
the recipe is a file named `Dockerfile`. If you are using Singularity, the
recipe is a file named `Singularity`.

**IMPORTANT SINGULARITY NOTE:** Actually **building** a Singularity image from a recipe
requires sudo access.  To work around this, a custom Dockerfile can be created
(following instructions here) and uploaded to Dockerhub or quay.io. The docker
image can then be pulled by Singularity without sudo commands. (If you use this
approach, you will use step 1 to build the Docker container, then upload it to
Dockerhub or Quay.io instead of using a local container. Basically, skip step 2.)

## Build Docker Containers

Dockerfiles contain directives like `FROM` and `RUN`; see the
[Dockerfile documentation](https://docs.docker.com/engine/reference/builder/#shell-form-entrypoint-example).

Here is a brief example Dockerfile that installs fastqc:

```
# Set the base image to miniconda
FROM continuumio/miniconda

# Include maintainer contact info
MAINTAINER Example McAuthor <author@example.com>

# Install fastqc
RUN conda config --add channels defaults \
    && conda config --add channels conda-forge \
    && conda config --add channels bioconda \
    && conda install -y openjdk >8.0.121 fastqc=0.11.7
```

Briefly, this uses a base image with miniconda installed using the `FROM`
directive, adds channels to conda, then installs fastqc and OpenJDK.

To actually build a Docker container from this recipe, use the `docker build`
command:

```
docker build -t <container_name> <path_to_Dockerfile>
```

For the fastqc example above, we would build the container like this:

```
docker build -t dahak_fastqc .
```

When a docker image is built, it is managed on disk by Docker,
so there is no external file created. To run a Docker container
using this fastqc container image, we pass the container image name
`docker_fastqc` to the `docker run` command.


## Build Singularity Containers

Singularity definition files are similar to, but different from,
Dockerfiles. See the [Singularity recipes](http://singularity.lbl.gov/docs-recipes#apps)
documentation. Also see the [Docker page](http://singularity.lbl.gov/archive/docs/v2-2/docs-docker)
of the Singularity documentation.

This is an example Singularity file that is equivalent to the fastqc Dockerfile
given above. This is in a file called `Singularityfile`:

```
Bootstrap: docker
From: continuumio/miniconda:latest
IncludeCmd: yes

# Installing the software in our image.
%post

    /opt/conda/bin/conda config --add channels defaults
    /opt/conda/bin/conda config --add channels conda-forge
    /opt/conda/bin/conda config --add channels bioconda
    /opt/conda/bin/conda install -y openjdk >8.0.121 fastqc=0.11.7
```

The header contains directives similar to the Dockerfile `FROM`
line, specifying that Singularity should use a miniconda base
image. The `RUN` commands in the Dockerfile become `%post`
commands, because they are run after the base container image
has been set up.

Singularity images are external files, unlike Docker 

To build the Singularity container image, we specify
the name of the (destination) Singularity image file,
then the name of the (source) Singularity recipe file:

```
sudo singlarity build dahak_fastqc.img Singuarityfile
```


## Step 2: Configure Snakemake to Use Custom Containers

**IMPORTANT SINGULARITY NOTE:** If you built a custom Docker image elsewhere to
avoid the sudo access required to build Singularity images, you should upload
your custom image to Dockerhub or Quay.io and use it like a normal remote
container.  Only follow the steps below if you have a local `*.simg` or `*.img`
file on disk.

In the Snakemake configuration for your workflow, set the `use_local` option to
`True` in the `biocontainers` section of the configuration, and specify the
name you gave the container image when you built it.

For example, if you built a local Singularity container

```
docker build -t dahak_fastqc .
```


