#!/bin/bash
#
# should be run from workflows/
# not from slurm/

function main() {
    pretrim
    #posttrim
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
    CLUSTER_JSON="slurm/cluster.json"
    JS="slurm/jobscript.sh"

    snakemake -p \
        -j 100 \
        --cluster-config ${CLUSTER_JSON} \
        --js ${JS} \
        --cluster "sbatch -A {cluster.account} -n {cluster.n} --export=SINGULARITY_BINDPATH={cluster.singularity_bindpath} --partition {cluster.partition} --mem {cluster.mem} -t {cluster.time}" \
        --use-singularity \
        ${target} 

    ### https://github.com/dib-lab/2017-paper-gather/blob/master/pipeline/hpcc/submit.sh
    ###
    ###snakemake                               \
    ###    -j 100                              \
    ###    --cluster-config hpcc/cluster.yaml  \
    ###    --js hpcc/jobscript.sh              \
    ###    --rerun-incomplete                  \
    ###    --keep-going                        \
    ###    --latency-wait 10                   \
    ###    --max-jobs-per-second 1             \
    ###    --use-conda                         \
    ###    --cluster "$QSUB" $@
}

main


