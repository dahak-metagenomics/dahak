#!/bin/bash

SINGULARITY_BINDPATH="data:/data" snakemake --use-singularity pre_trim

SINGULARITY_BINDPATH="data:/data" snakemake --use-singularity post_trim

snakemake --forceall --dag post_trim | dot -Tpdf > dag.pdf
