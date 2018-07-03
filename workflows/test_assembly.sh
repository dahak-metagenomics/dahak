#!/bin/bash

#SINGULARITY_BINDPATH="data:/data" snakemake -n -p --use-singularity metaspades
#SINGULARITY_BINDPATH="data:/data" snakemake -p --use-singularity metaspades

snakemake -n -p assembly_workflow_metaspades
snakemake -n -p assembly_workflow_megahit

