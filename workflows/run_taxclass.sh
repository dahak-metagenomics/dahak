#!/bin/bash

function main() {
    taxclass_signatures
    taxclass_gather
    taxclass_kaijureport
    taxclass_kaijureport_filtered
    taxclass_kaijureport_filteredclass
}

function taxclass_signatures() {
    run taxonomic_classification_signatures_workflow
}

function taxclass_gather() {
    run taxonomic_classification_gather_workflow
}

function taxclass_kaijureport() {
    run taxonomic_classification_kaijureport_workflow
}

function taxclass_kaijureport_filtered() {
    run taxonomic_classification_kaijureport_filtered_workflow
}

function taxclass_kaijureport_filteredclass() {
    run taxonomic_classification_kaijureport_filteredclass_workflow
}

function run() {
    target=$1
    snakemake --forceall --dag ${target} | dot -Tpdf > dag_${target}.pdf
    SINGULARITY_BINDPATH="data:/data" snakemake -p --use-singularity ${target}
}

main
