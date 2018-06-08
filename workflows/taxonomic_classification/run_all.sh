#!/bin/bash

#snakemake --forceall --dag sbts | dot -Tpdf > dag.pdf

SINGULARITY_BINDPATH="data:/data" snakemake --use-singularity --printshellcmds merge

