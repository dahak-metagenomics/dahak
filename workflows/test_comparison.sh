#!/bin/bash

function main() {
    comparisonread
    comparisonassembly
    comparisonall
}

function comparisonread() {
    doit "comparison_workflow_reads"
}

function comparisonassembly() {
    doit "comparison_workflow_assembly"
}

function comparisonall() {
    doit "comparison_workflow_reads_assembly"
}

function doit() {
    target=$1
    snakemake -n -p ${target}
    snakemake --forceall --dag ${target} | dot -Tpdf > dag_${target}.pdf
    echo "----------------------"
    echo "rule: ${target}"
    echo "task graph: dag_${target}.pdf"
    echo "----------------------"
    echo ""
}

main
