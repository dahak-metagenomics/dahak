#!/bin/bash

snakemake --forceall --dag comparison_workflow_assembly | dot -Tpdf > dag.pdf

