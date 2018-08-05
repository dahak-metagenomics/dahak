#!/bin/bash

function main() {
    #metaspades
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

    CLUSTER_JSON="slurm/cluster.json"
    JS="slurm/jobscript.sh"

    snakemake -p \
        -j 100 \
        --cluster-config ${CLUSTER_JSON} \
        --js ${JS} \
        --cluster "sbatch -A {cluster.account} -n {cluster.n} --export=SINGULARITY_BINDPATH={cluster.singularity_bindpath} --partition {cluster.partition} --mem {cluster.mem} -t {cluster.time}" \
        --use-singularity \
        ${target} 
}

main

