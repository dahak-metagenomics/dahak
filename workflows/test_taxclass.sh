#!/bin/bash

snakemake -n -p taxonomic_classification_workflow
snakemake --forceall --dag taxonomic_classification_workflow | dot -Tpdf > dag_taxcass.pdf
echo "----------------------"
echo "rule: taxonomic_classification_workflow"
echo "task graph: dag_taxclass.pdf"
echo "----------------------"
echo ""

#snakemake -n -p runkaiju
#snakemake -n -p runkrona

