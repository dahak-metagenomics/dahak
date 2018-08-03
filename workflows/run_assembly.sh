#!/bin/bash

function main() {
    metaspades
    megahit
}

function metaspades() {
    run assembly_workflow_metaspades
}

function megahit() {
    run assembly_workflow_megahit
}

function run() {
    target=$1
    snakemake --forceall --dag ${target} | dot -Tpdf > dag_${target}.pdf
    SINGULARITY_BINDPATH="data:/data" snakemake -p --use-singularity ${target}
}

main
