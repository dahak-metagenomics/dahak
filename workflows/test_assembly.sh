#!/bin/bash

function main() {
    metaspades
    megahit
}

function metaspades() {
    doit "assembly_workflow_metaspades"
}

function megahit() {
    doit "assembly_workflow_megahit"
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
