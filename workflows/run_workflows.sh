#!/bin/bash

# Read filtering workflow
#SINGULARITY_BINDPATH="data:/data" snakemake -p --use-singularity read_filtering_workflow

# Assembly workflows
SINGULARITY_BINDPATH="data:/data" snakemake -p --use-singularity assembly_workflow_metaspades
#SINGULARITY_BINDPATH="data:/data" snakemake -p --use-singularity assembly_workflow_megahit

 Comparison workflows
SINGULARITY_BINDPATH="data:/data" snakemake -p --use-singularity comparison_workflow_reads
SINGULARITY_BINDPATH="data:/data" snakemake -p --use-singularity comparison_workflow_assembly
SINGULARITY_BINDPATH="data:/data" snakemake -p --use-singularity comparison_workflow_reads_assembly
