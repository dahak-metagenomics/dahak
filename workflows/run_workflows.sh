#!/bin/bash

## Works
#SINGULARITY_BINDPATH="data:/data" snakemake -p --use-singularity comparison_workflow_reads

# In progress
SINGULARITY_BINDPATH="data:/data" snakemake -p --use-singularity comparison_workflow_assembly
