#!/bin/bash

#snakemake --forceall --dag sbts | dot -Tpdf > dag.pdf

#SINGULARITY_BINDPATH="data:/data" snakemake --use-singularity --printshellcmds merge

#SINGULARITY_BINDPATH="data:/data" snakemake --use-singularity --printshellcmds usekaiju

#SINGULARITY_BINDPATH="data:/data" snakemake --use-singularity --printshellcmds runkaiju

SINGULARITY_BINDPATH="data:/data" snakemake --use-singularity --printshellcmds runkrona

