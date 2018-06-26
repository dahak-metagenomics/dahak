#!/bin/bash

#snakemake --forceall --dag sbts | dot -Tpdf > dag.pdf

#SINGULARITY_BINDPATH="data:/data" snakemake -n --use-singularity --printshellcmds megahit
SINGULARITY_BINDPATH="data:/data" snakemake --use-singularity --printshellcmds megahit

