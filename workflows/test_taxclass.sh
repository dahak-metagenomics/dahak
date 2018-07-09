#!/bin/bash

function main() {
    #taxclass_signatures
    #taxclass_gather
    #taxclass_kaijureport
    #taxclass_kaijureport_filtered
    taxclass_kaijureport_filteredclass
}

function taxclass_signatures() {
    doit taxonomic_classification_signatures_workflow
}

function taxclass_gather() {
    doit taxonomic_classification_gather_workflow
}

function taxclass_kaijureport() {
    doit taxonomic_classification_kaijureport_workflow
}

function taxclass_kaijureport_filtered() {
    doit taxonomic_classification_kaijureport_filtered_workflow
}

function taxclass_kaijureport_filteredclass() {
    doit taxonomic_classification_kaijureport_filteredclass_workflow
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

