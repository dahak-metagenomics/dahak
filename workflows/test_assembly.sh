#!/bin/bash

#snakemake --forceall --dag sbts | dot -Tpdf > dag.pdf

#SINGULARITY_BINDPATH="data:/data" snakemake -n --use-singularity --printshellcmds metaspades
#SINGULARITY_BINDPATH="data:/data" snakemake --use-singularity --printshellcmds metaspades

#snakemake -n -p metaspades
snakemake -n -p megahit
