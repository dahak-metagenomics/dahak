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
    SINGULARITY_BINDPATH="data:/data" 
    CLUSTER_JSON="cluster.json"
    snakemake -p \
        -j 99 \
        --cluster-config cluster.json \
        --cluster "sbatch -A {cluster.account} -p {cluster.partition} -n {cluster.n} -t {cluster.time}" \
        --use-singularity ${target} 
}

main


