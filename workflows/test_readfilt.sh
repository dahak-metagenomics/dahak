#!/bin/bash

#snakemake -n -p read_filtering_pretrim_workflow
#snakemake --forceall --dag read_filtering_pretrim_workflow | dot -Tpdf > dag_readfilt_pre.pdf
#echo "----------------------"
#echo "rule: read_filtering_workflow"
#echo "task graph: dag_readfilt_pre.pdf"
#echo "----------------------"
#echo ""

snakemake -n -p read_filtering_posttrim_workflow
snakemake --forceall --dag read_filtering_posttrim_workflow | dot -Tpdf > dag_readfilt_post.pdf
echo "----------------------"
echo "rule: read_filtering_posttrim_workflow"
echo "task graph: dag_readfilt_post.pdf"
echo "----------------------"
echo ""
