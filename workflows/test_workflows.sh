#!/bin/bash

## Read filtering
#snakemake -n -p pre_trim
#snakemake -n -p post_trim
#
## Taxonomic classification
#snakemake -n -p usekaiju
#snakemake -n -p runkaiju
#snakemake -n -p runkrona
#
## Assembly
#snakemake -n -p metaspades
#snakemake -n -p megahit

# Comparison
snakemake -n -p doit

