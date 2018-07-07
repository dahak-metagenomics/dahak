#!/bin/bash

function main() {
    #comparisonread
    #comparisonassembly
    comparisonall
}

function comparisonread() {
    snakemake -n -p comparison_workflow_reads
    snakemake --forceall --dag comparison_workflow_reads  | dot -Tpdf > dag_comp_reads.pdf
    echo "----------------------"
    echo "rule: comparison_workflow_reads"
    echo "task graph: dag_comp_reads.pdf"
    echo "----------------------"
    echo ""
}

function comparisonassembly() {
    snakemake -n -p comparison_workflow_assembly
    snakemake --forceall --dag comparison_workflow_assembly  | dot -Tpdf > dag_comp_assembly.pdf
    echo "----------------------"
    echo "rule: comparison_workflow_assembly"
    echo "task graph: dag_comp_assembly.pdf"
    echo "----------------------"
    echo ""
}

function comparisonall() {
    snakemake -n -p comparison_workflow_reads_assembly
    snakemake --forceall --dag comparison_workflow_reads_assembly  | dot -Tpdf > dag_comp_reads_assembly.pdf
    echo "----------------------"
    echo "rule: comparison_workflow_reads_assembly"
    echo "task graph: dag_comp_reads_assembly.pdf"
    echo "----------------------"
    echo ""
}

main
