#!/bin/bash

#snakemake --forceall --dag sbts | dot -Tpdf > dag.pdf

#SINGULARITY_BINDPATH="data:/data" snakemake -n -p --use-singularity merge
#SINGULARITY_BINDPATH="data:/data" snakemake -n -p --use-singularity usekaiju
#SINGULARITY_BINDPATH="data:/data" snakemake -n -p --use-singularity runkaiju
#SINGULARITY_BINDPATH="data:/data" snakemake -n -p --use-singularity runkrona

#snakemake -n -p usekaiju
#snakemake -n -p runkaiju
snakemake -n -p runkrona
