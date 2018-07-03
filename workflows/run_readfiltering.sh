#!/bin/bash

# Read filtering workflow
SINGULARITY_BINDPATH="data:/data" snakemake -p --use-singularity read_filtering_workflow

