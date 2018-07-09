#!/bin/bash

function main() {
    pretrim
    posttrim
}

function pretrim() {
    run read_filtering_pretrim_workflow
}

function posttrim() {
    run read_filtering_posttrim_workflow
}

function run() {
    target=$1
    snakemake --forceall --dag ${target} | dot -Tpdf > dag_${target}.pdf
    SINGULARITY_BINDPATH="data:/data" snakemake -p --use-singularity ${target}
}

main
