#!/bin/bash

function main() {
    #taxclass_signatures
    #taxclass_filter
    taxclass_gather
    #taxclass
}

function taxclass_signatures() {
    snakemake -n -p taxonomic_classification_workflow_signatures
    snakemake --forceall --dag taxonomic_classification_workflow_signatures | dot -Tpdf > dag_taxclass_sig.pdf
    echo "----------------------"
    echo "rule: taxonomic_classification_sig"
    echo "task graph: dag_taxclass_sig.pdf"
    echo "----------------------"
    echo ""
}

function taxclass_gather() {
    snakemake -n -p taxonomic_classification_gather_workflow
    snakemake --forceall --dag taxonomic_classification_gather_workflow | dot -Tpdf > dag_taxclass_gather.pdf
    echo "----------------------"
    echo "rule: taxonomic_classification_gather_workflow"
    echo "task graph: dag_taxclass_gather.pdf"
    echo "----------------------"
    echo ""
}

function taxclass_filter() {
    snakemake -n -p taxonomic_classification_filter_workflow
    snakemake --forceall --dag taxonomic_classification_filter_workflow | dot -Tpdf > dag_taxclass_filter.pdf
    echo "----------------------"
    echo "rule: taxonomic_classification_filter_workflow"
    echo "task graph: dag_taxclass_filter.pdf"
    echo "----------------------"
    echo ""
}

function taxclass() {
    snakemake -n -p taxonomic_classification_workflow
    snakemake --forceall --dag taxonomic_classification_workflow | dot -Tpdf > dag_taxclass.pdf
    echo "----------------------"
    echo "rule: taxonomic_classification_workflow"
    echo "task graph: dag_taxclass.pdf"
    echo "----------------------"
    echo ""
}

main
