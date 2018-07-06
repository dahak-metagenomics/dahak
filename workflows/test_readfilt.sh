#!/bin/bash

snakemake -n -p read_filtering_workflow

snakemake --forceall --dag read_filtering_workflow | dot -Tpdf > dag_readfilt.pdf

echo "----------------------"
echo "created task graph figure in dag_readfilt.pdf"
echo "----------------------"
echo ""

