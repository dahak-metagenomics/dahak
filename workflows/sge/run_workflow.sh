#!/bin/bash
#
# this uses the configuration in cluster.json

snakemake -j 999 \
    --cluster-config cluster.json \
    --cluster "sbatch -A {cluster.account} -p {cluster.partition} -n {cluster.n}  -t {cluster.time}"

