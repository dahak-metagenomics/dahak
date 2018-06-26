# fastqc Dockerfile

This dockerfile downloads fastqc from a recent version of miniconda.

Build the docker image:

```
docker build -t dahak_fastqc .
```

(if your Dockerfile has a different name than Dockerfile, specify it with the
`-f <filename>` flag). Test out the image:

```
docker run -it dahak_fastqc fastqc --help
```

should print out fastqc help.


# fastqc Singularityfile

To build it:

```
sudo singularity build docker_fastqc.img Singularityfile
```

To run it:

```
singularity run docker_fastqc.img fastqc --help
```

