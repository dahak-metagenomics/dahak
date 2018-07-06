#!/bin/bash

#snakemake --forceall --dag comparison_workflow_reads          | dot -Tpdf > dag.pdf
#snakemake --forceall --dag comparison_workflow_assembly       | dot -Tpdf > dag.pdf
#snakemake --forceall --dag comparison_workflow_reads_assembly | dot -Tpdf > dag.pdf

#SINGULARITY_BINDPATH="data:/data" snakemake -n -p --use-singularity doit

snakemake -n -p comparison_workflow_reads
#snakemake -n -p comparison_workflow_assembly
#snakemake -n -p comparison_workflow_reads_assembly

