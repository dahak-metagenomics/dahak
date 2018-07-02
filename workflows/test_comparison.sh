#!/bin/bash

#snakemake --forceall --dag sbts | dot -Tpdf > dag.pdf

#SINGULARITY_BINDPATH="data:/data" snakemake -n -p --use-singularity doit
snakemake -n -p doit

