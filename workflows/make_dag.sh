#!/bin/bash

snakemake --forceall --dag sbts | dot -Tpdf > dag.pdf

