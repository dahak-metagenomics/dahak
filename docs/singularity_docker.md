# Docker and Singularity

- Containerization technologies
- Like a virtual machine but OS only
- enables consistent reproducible environment

Basic commands:

- docker pull/singularity pull
- docker build/singularity build
- docker run/singularity run
- docker exec/singularity exec

Basic build workflow:

- pulling container images
    - pulling a container image from remote store
    - pulling biocontainer image from quay.io
- building container images
    - create Dockerfile, build docker container
    - create singularity file, build singularity container
    - SINGULARITY_PULLFOLDER
- using in dahak
    - using remote container image
    - using local container image


