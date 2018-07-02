#!/bin/bash

## Read filtering
#snakemake -n -p read_filtering_workflow

# Taxonomic classification

## Assembly workflows
#snakemake -n -p assembly_workflow_megahit
#snakemake -n -p assembly_workflow_metaspades
#snakemake -n -p assembly_workflow_all

# Comparison workflows
#snakemake -n -p comparison_workflow_all
snakemake -n -p comparison_workflow_reads
#snakemake -n -p comparison_workflow_assembly
#snakemake -n -p comparison_workflow_reads_assembly
