#!/bin/bash

SINGULARITY_BINDPATH="data:/data" snakemake -p --use-singularity assembly_workflow_metaspades 

SINGULARITY_BINDPATH="data:/data" snakemake -p --use-singularity assembly_workflow_megahit

