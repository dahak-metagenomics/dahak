# HPC Quick Start

Let's run through the assembly workflow using a SLURM batch
job system. The steps covered below were tested on the University 
of Virginia's [Rivanna cluster](https://arcs.virginia.edu/rivanna).

## Useful Snakemake Flags

Two useful snakemake flags that you can add are:

* `--dryrun` or `-n`: do a dry run of the workflow but do not actually run any commands
* `--printshellcmds` or `-p`: print the shell commands that are being executed
    (or would be executed if combined with `--dryrun`)


## Assembly Workflow on HPC

We will run two assembler workflows via the SLURM system using the Megahit 
assembler workflow implemented in Dahak.

(See the [Assembly Snakemake](assembly_snakemake.md) page for details on
the workflow parameters.)

### Cluster Files

Start by creating the cluster configuration file, which specifies which rules
use which batch job parameters. 

```
cat > slurm_cluster.json <<EOF
{
    "__default__" : {
        "account" : "dahak",
        "time" : "08:00:00",
        "partition" : "standard",
        "n" : 1,
        "mem" : "128000",
        "singularity_bindpath" : "data:/data"
    },

    "download_reads" : {
        "time" : "00:15:00",
    },

    "interleave_reads" : {
        "time" : "18:00:00",
        "mem" : "256000"
    }
}
EOF
```

This specifies that all rules should use 8 hours of walltime by default,
except for the download reads rule which should request 15 minutes of walltime,
and the interleave reads rule which should request 18 hours of walltime.

On Rivanna there are a large number of 128 GB RAM nodes and a smaller number of
256 GB nodes. By default all rules request 128 GB RAM nodes, while the interleave
reads rule requests a 256 GB RAM node. 

Now create a job script, which is the script that is run on the compute node
itself once the job goes through:

```
cat > slurm_jobscript.sh << EOF
#!/bin/bash

module load anaconda3
module load singularity

{exec_job}
EOF
chmod +x slurm_jobscript.sh
```

Finally, here is what a command to submit a SLURM job on Rivanna looks like
(**note: don't copy and paste this command**):
templated variables:

```
        sbatch -A {cluster.account} \
            -n {cluster.n} \
            --export=SINGULARITY_BINDPATH={cluster.singularity_bindpath} \
            --partition {cluster.partition} \
            --mem {cluster.mem} \
            -t {cluster.time}
```

This is the command that Snakemake uses to submit jobs for each rule.
`{cluster.*}` variables come from the cluster configuration JSON above.

### Dahak Files

Following the [Quickstart](quickstart.md), we prepare to run the
Dahak Megahit assembly workflow as follows.

Create a JSON file that defines a Snakemake configuration dictionary:

```json
cat > assembly.json <<EOF
{
    "files" : {
        "SRR606249_subset10_1_reads.fq.gz" :  "files.osf.io/v1/resources/dm938/providers/osfstorage/59f10134b83f69026377611b",
        "SRR606249_subset10_2_reads.fq.gz" :  "files.osf.io/v1/resources/dm938/providers/osfstorage/59f101f26c613b026330e53a",
    },

    "workflows" : {
        "assembly_workflow_megahit" : {
            "sample"    : ["SRR606249_subset10"],
            "qual"      : ["2","30"],
        }
    },
}
EOF
```

### Snakemake Command

Once these files are all in the same directory, Snakemake is ready to
run the job. (This is a good time to start a screen using the `screen`
command.) 

Copy and paste the following to create a script to run the Dahak assembly
workflow on the slurm system using Snakemake:

```
CLUSTER_JSON="slurm_cluster.json"
JS="slurm_jobscript.sh"

snakemake -p \
    -j 100 \
    --cluster-config ${CLUSTER_JSON} \
    --js ${JS} \
    --cluster "sbatch -A {cluster.account} -n {cluster.n} --export=SINGULARITY_BINDPATH={cluster.singularity_bindpath} --partition {cluster.partition} --mem {cluster.mem} -t {cluster.time}" \
    --use-singularity \
    assembly_workflow_megahit
```

This runs up to 100 jobs at a time; adjust the `-j` flag as needed.
(Related: [Cluster Execution](https://snakemake.readthedocs.io/en/stable/executable.html#cluster-execution)
in the Snakemake documentation).

