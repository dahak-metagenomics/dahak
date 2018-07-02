#!/bin/bash

#snakemake --forceall --dag post_trim | dot -Tpdf > dag.pdf

#SINGULARITY_BINDPATH="data:/data" snakemake -n -p --use-singularity pre_trim
#SINGULARITY_BINDPATH="data:/data" snakemake -n -p --use-singularity post_trim

#snakemake -n -p pre_trim
#snakemake -n -p post_trim

snakemake -n -p data/SRR606249_subset10_2_trim30.fq.gz
