# Quick Start

Let's run through the entire process start to finish.

## Useful Snakemake Flags

Two useful snakemake flags that you can add are:

* `--dryrun` or `-n`: do a dry run of the workflow but do not actually run any commands
* `--printshellcmds` or `-p`: print the shell commands that are being executed
    (or would be executed if combined with `--dryrun`)

## Read Filtering

We will run two variations of the read filtering workflow, and perform a quality
assessment of our reads both before and after quality trimming.

Before you begin, make sure you have Singularity installed as in
the [Installing](installing.md) documentation.

Start by cloning a copy of the repository:

```bash
git clone -b snakemake/comparison https://github.com/dahak-metagenomics/dahak
```

then move into the `workflows/` directory of the Dahak repository:

```bash
cd dahak/workflows/
```

Now create a JSON file that defines a Snakemake configuration dictionary.
This file should:

* Provide URLs at which each read filtering file can be accessed
* Provide a set of quality trimming values to use (2 and 30)
* Specify which read files should be used for the workflow
* Specify a container image from the biocontainers project to use with
  Singluarity
* Set all read filtering parameters

(See the [Read Filtering Snakemake](readfilt_snakemake.md) page for details on
these options.)
 
Copy and paste the following:

```
cat > readfilt.json <<EOF
{
    "files" : {
        "SRR606249_subset10_1_reads.fq.gz" :  "files.osf.io/v1/resources/dm938/providers/osfstorage/59f10134b83f69026377611b",
        "SRR606249_subset10_2_reads.fq.gz" :  "files.osf.io/v1/resources/dm938/providers/osfstorage/59f101f26c613b026330e53a",
    },

    "workflows" : {
        "read_filtering_pretrim_workflow" : {
            "sample"    : ["SRR606249_subset10"],
        },
        "read_filtering_posttrim_workflow" : {
            "sample"    : ["SRR606249_subset10"],
        },
    },
}
EOF
```

This creates a workflow configuration file `readfilt.json` that will
download the example data files and configure one or more workflows.

We will run two workflows: one pre-trimming
quality assessment, and one post-trimming quality assessment, so we call
Snakemake and pass it two build targets: `read_filtering_pretrim_workflow`
and `read_filtering_posttrim_workflow`.

```bash
export SINGULARITY_BINDPATH="data:/data"

snakemake --use-singularity \
          --configfile=readfilt.json \
          read_filtering_pretrim_workflow read_filtering_posttrim_workflow
```

This command outputs FastQC reports for the untrimmed reads as well as
the reads trimmed at both quality cutoffs, and also outputs the trimmed
PE reads and the orphaned reads. All files are placed in the `data/`
subdirectory.

<br />
<br />

## Assembly

We will run two assembler workflows using the Megahit assembler workflow
implemented in Dahak.

(See the [Assembly Snakemake](assembly_snakemake.md) page for details on
these options.)

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

To run the assembly workflow with
both assemblers, we call Snakemake with the `assembly_workflow_all` target.

```bash
export SINGULARITY_BINDPATH="data:/data"

snakemake --use-singularity \
          --configfile=assembly.json \
          assembly_workflow_megahit
```

<br />
<br />


## Comparison

In this section we will run a comparison workflow to compute sourmash
signatures for both filtered reads and assemblies, and compare the
computed signatures to a reference database.

Create a config file:

(See the [Comparison Snakemake](comparison_snakemake.md) page for details on
these options.)

Copy and paste the following:

```
cat > comparison.json <<EOF
{
    "files" : {
        "SRR606249_subset10_1_reads.fq.gz" :  "files.osf.io/v1/resources/dm938/providers/osfstorage/59f10134b83f69026377611b",
        "SRR606249_subset10_2_reads.fq.gz" :  "files.osf.io/v1/resources/dm938/providers/osfstorage/59f101f26c613b026330e53a"
    },

    "workflows" : {
        "comparison_workflow_reads" : {
            "kvalue"    : ["21","31","51"],
        }
    },
}
EOF
```

Now, run the `comparison_workflow_reads` workflow:

```bash
export SINGULARITY_BINDPATH="data:/data"

snakemake --use-singularity \
          --configfile=comparison.json \
          comparison_workflow_reads
```


<br />
<br />

## Taxonomic Classification

### Taxonomic Classification with Sourmash

There are a number of taxonomic classification workflows
implemented in Dahak. In this section we cover the use
of the sourmash tool for taxonomic classification.

Before you begin, make sure you have everything listed on the
[Installing](installing.md) page available on your command line.

There are two taxonomic classification build rules that use sourmash:
`taxonomic_classification_signatures_workflow` and
`taxonomic_classification_gather_workflow`.

#### Signatures Workflow

The signatures workflow uses sourmash to compute k-mer signatures from read
files. This is essentially the same as the compute signatures step in the
comparison workflow.

(See the [Taxonomic Classification Snakemake](taxclass_snakemake.md) page for
details on this workflow.)

```
cat > compute.json <<EOF
{
    "files" : {
        "SRR606249_subset10_1_reads.fq.gz" :  "files.osf.io/v1/resources/dm938/providers/osfstorage/59f10134b83f69026377611b",
        "SRR606249_subset10_2_reads.fq.gz" :  "files.osf.io/v1/resources/dm938/providers/osfstorage/59f101f26c613b026330e53a",
    },

    "workflows" : {
        "taxonomic_classification_signatures_workflow" : {
            "sample"  : ["SRR606249_subset10"],
            "qual" : ["2","30"]
        }
    }
}
EOF
```

```
export SINGULARITY_BINDPATH="data:/data"

snakemake --use-singularity \
        --configfile=compute.json \
        taxonomic_classification_signatures_workflow
```

#### Gather Workflow

The gather workflow uses sourmash to (gather?) signatures 
computed from read files and compare them to signatures stored
in a genome database.

Create a JSON file for the taxonomic classification gather workflow 
that defines a Snakemake configuration dictionary:

```
cat > gather.json <<EOF
{
    "files" : {
        "SRR606249_subset10_1_reads.fq.gz" :  "files.osf.io/v1/resources/dm938/providers/osfstorage/59f10134b83f69026377611b",
        "SRR606249_subset10_2_reads.fq.gz" :  "files.osf.io/v1/resources/dm938/providers/osfstorage/59f101f26c613b026330e53a",
    },

    "workflows" : {
        "taxonomic_classification_gather_workflow" : {
            "sample"  : ["SRR606249_subset10"],
            "qual" : ["2","30"]
        }
    }
}
EOF
```

To run the gather workflow, we call Snakemake with the
`taxonomic_classification_gather_workflow` target.


```bash
export SINGULARITY_BINDPATH="data:/data"

snakemake --use-singularity \
          --configfile=taxkaiju.json \
          taxonomic_classification_gather_workflow
```

### Taxonomic Classification with Kaiju

There are several taxonomic classification workflows in Dahak that 
use the Kaiju tool as well. This section covers those workflows.

There are three taxonomic classification build rules that use kaiju:

* `taxonomic_classification_kaijureport_workflow`
* `taxonomic_classification_kaijureport_filtered_workflow`
* `taxonomic_classification_kaijureport_filteredclass_workflow`


#### Kaiju Report Workflow

Create a JSON file that defines a Snakemake configuration dictionary:

```
cat > taxkaiju.json <<EOF
{
    "files" : {
        "SRR606249_subset10_1_reads.fq.gz" :  "files.osf.io/v1/resources/dm938/providers/osfstorage/59f10134b83f69026377611b",
        "SRR606249_subset10_2_reads.fq.gz" :  "files.osf.io/v1/resources/dm938/providers/osfstorage/59f101f26c613b026330e53a",
    },

    "workflows" : {
        "taxonomic_classification_kaijureport_workflow" : {
            "sample"  : ["SRR606249_subset10"],
            "qual" : ["2","30"]
        }
    }
}
EOF
```

To run the taxonomic classification workflow
to generate a kaiju report, we call Snakemake with the
`taxonomic_classification` target.


```bash
export SINGULARITY_BINDPATH="data:/data"

snakemake --use-singularity \
          --configfile=taxkaiju.json \
          taxonomic_classification_kaijureport_workflow
```


#### Kaiju Filtered Species Report Workflow

The filtered kaiju workflow filters for species whose reads
compose less than N% of the total reads, where N is a parameter
set by the user. 

Copy and paste the following:

```
cat > taxkaiju_filtered.json <<EOF
{
    "files" : {
        "SRR606249_subset10_1_reads.fq.gz" :  "files.osf.io/v1/resources/dm938/providers/osfstorage/59f10134b83f69026377611b",
        "SRR606249_subset10_2_reads.fq.gz" :  "files.osf.io/v1/resources/dm938/providers/osfstorage/59f101f26c613b026330e53a",
    },

    "taxonomic_classification" : {
        "filter_taxa" : {
            "pct_threshold" : 1
        }
    },

    "workflows" : {
        "taxonomic_classification_kaijureport_filtered_workflow" : {
            "sample"  : ["SRR606249_subset10"],
            "qual" : ["2","30"]
        }
    }
}
EOF
```

To run the taxonomic classification filtered report workflow,
we call Snakemake with the
`taxonomic_classification_kaijureport_filtered_workflow` target.


```bash
export SINGULARITY_BINDPATH="data:/data"

snakemake --use-singularity \
          --configfile=taxkaiju_filtered.json \
          taxonomic_classification_kaijureport_filtered_workflow
```


#### Kaiju Filtered Species by Class Report Workflow

The last workflow implements filtering but also implements reporting
the taxa level reported by kaiju. This iuses the "genus" taxonomic rank
level by default.

Copy and paste the following:

```
cat > taxkaiju_filteredclass.json <<EOF
{
    "files" : {
        "SRR606249_subset10_1_reads.fq.gz" :  "files.osf.io/v1/resources/dm938/providers/osfstorage/59f10134b83f69026377611b",
        "SRR606249_subset10_2_reads.fq.gz" :  "files.osf.io/v1/resources/dm938/providers/osfstorage/59f101f26c613b026330e53a",
    },

    "taxonomic_classification" : {
        "kaiju_report" : {
            "taxonomic_rank" : "genus"
        }
    },

    "workflows" : {

        "taxonomic_classification_kaijureport_filteredclass_workflow" : {
            "sample"  : ["SRR606249_subset10"],
            "qual" : ["2","30"]
        },
    }
}
```

To run the taxonomic classification workflow
to generate this kaiju report, we call Snakemake with the
`taxonomic_classification_kaijureport_filteredclass_workflow` target.

```bash
export SINGULARITY_BINDPATH="data:/data"

snakemake --use-singularity \
          --configfile=taxkaiju_filtered.json \
          taxonomic_classification_kaijureport_filteredclass_workflow
```




