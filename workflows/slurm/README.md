# Running Dahak with SLURM

## Read Filtering

To run Dahak's read filtering workflow on a SLURM
cluster, we use a cluster configuration JSON file and
specify how Snakemake should combine these into a
cluster submission command. This allows us to specify
default job walltime, memory, cluster parition, and
other batch parameters from a JSON file at the rules
level.

```
$ snakemake -p \
        -j 100 \
        --cluster-config cluster.json \
        --cluster "sbatch -A {cluster.account} -p {cluster.partition} -n {cluster.n} -t {cluster.time}" \
        --use-singularity \
        read_filtering_posttrim_workflow
```

The contents of `cluster.json` are:

```
cat > cluster.json <<EOF


EOF
```

The basic format of the file is to define
key value pairs for different batch submission
parameters, which are used in a final batch 
command.

Default values are stored under the key `__default__`.

Rule-specific values are stored under a key
equal to the name of the rule, like `download_reads`.

[partition names (bottom of page)](https://arcs.virginia.edu/rivanna)

