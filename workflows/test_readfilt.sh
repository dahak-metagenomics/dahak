#!/bin/bash

snakemake --forceall --dag post_trim | dot -Tpdf > dag.pdf

SINGULARITY_BINDPATH="data:/data" snakemake -n -p --use-singularity pre_trim

SINGULARITY_BINDPATH="data:/data" snakemake -n -p --use-singularity post_trim

