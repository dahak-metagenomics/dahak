#!/bin/bash

function main() {
    pretrim
    posttrim
}

function pretrim() {
    doit read_filtering_pretrim_workflow
}

function posttrim() {
    doit read_filtering_posttrim_workflow
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
