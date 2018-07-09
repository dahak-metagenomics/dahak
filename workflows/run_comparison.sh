#!/bin/bash

function main() {
    comparisonread
    comparisonassembly
    comparisonall
}

function comparisonread() {
    run comparison_workflow_reads
}

function comparisonassembly() {
    run comparison_workflow_assembly
}

function comparisonall() {
    run comparison_workflow_reads_assembly
}

function run() {
    target=$1
    snakemake --forceall --dag ${target} | dot -Tpdf > dag_${target}.pdf
    SINGULARITY_BINDPATH="data:/data" snakemake -p --use-singularity ${target}
}

main

