#!/bin/bash

snakemake -n -p read_filtering_workflow
snakemake --forceall --dag read_filtering_workflow | dot -Tpdf > dag_readfilt.pdf
echo "----------------------"
echo "rule: read_filtering_workflow"
echo "task graph: dag_readfilt.pdf"
echo "----------------------"
echo ""

