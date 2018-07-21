# Quick Start

Let's run through the entire process start to finish.


### Read Filtering

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

### Assembly

We will run two assembler workflows using the two assemblers
implemented in Dahak: SPAdes and Megahit.

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

As before, this creates an assembly configuration file that sets up
a data set up for assembly.

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


### Comparison

In this section we will run a comparison workflow to compute sourmash
signatures for both filtered reads and assemblies, and compare the
computed signatures to a reference database.

Create a config file:

(See the [Comparison Snakemake](comparison_snakemake.md) page for details on
these options.)

```
cat > comparison.json <<EOF
{
    "files" : {
        "SRR606249_1_reads.fq.gz" :           "files.osf.io/v1/resources/dm938/providers/osfstorage/59f0f9156c613b026430dbc7",
        "SRR606249_2_reads.fq.gz" :           "files.osf.io/v1/resources/dm938/providers/osfstorage/59f0fc7fb83f69026076be47",
        "SRR606249_subset10_1_reads.fq.gz" :  "files.osf.io/v1/resources/dm938/providers/osfstorage/59f10134b83f69026377611b",
        "SRR606249_subset10_2_reads.fq.gz" :  "files.osf.io/v1/resources/dm938/providers/osfstorage/59f101f26c613b026330e53a",
        "SRR606249_subset25_1_reads.fq.gz" :  "files.osf.io/v1/resources/dm938/providers/osfstorage/59f1039a594d900263120c38",
        "SRR606249_subset25_2_reads.fq.gz" :  "files.osf.io/v1/resources/dm938/providers/osfstorage/59f104ed594d90026411f486"
    },

    "workflows" : {
        "comparison_workflow_reads" : {
            "kvalue"    : ["21","31","51"],
        }
    },
}
EOF
```

Now, run the `comparison_workflow_reads`.

```bash
export SINGULARITY_BINDPATH="data:/data"

snakemake --use-singularity \
        --configfile=comparison.json \
        comparison_workflow_reads
```


<br />
<br />

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
cat > classify.json <<EOF
{
    "files" : {
        "SRR606249_subset10_1_reads.fq.gz" :  "files.osf.io/v1/resources/dm938/providers/osfstorage/59f10134b83f69026377611b",
        "SRR606249_subset10_2_reads.fq.gz" :  "files.osf.io/v1/resources/dm938/providers/osfstorage/59f101f26c613b026330e53a",
    },

    "taxonomic_classification_signatures_workflow" : {
        "sample"  : ["SRR606249_subset10"],
        "qual" : ["2","30"]
    },
}
EOF
```

```
export SINGULARITY_BINDPATH="data:/data"

snakemake --use-singularity \
        --configfile=classify.json \
        taxonomic_classification_signatures_workflow
```

#### Gather Workflow

The gather workflow uses sourmash to (gather?) signatures 
computed from read files and compare them to signatures stored
in a genome database.

Create a JSON file for the taxonomic classification gather workflow 
that defines a Snakemake configuration dictionary. This file should:

* Provide URLs at which each read filtering file can be accessed
* Provide a set of quality trimming values to use (2 and 30)
* Set all read filtering parameters (for simplicity, we will set each
    parameter to its default value)
* Set filenames for sourmash, kaiju, and krona reports
* Set which databases to use for sourmash








    run taxonomic_classification_signatures_workflow
    run taxonomic_classification_gather_workflow
    run taxonomic_classification_kaijureport_workflow
    run taxonomic_classification_kaijureport_filtered_workflow
    run taxonomic_classification_kaijureport_filteredclass_workflow


```
{
    "files" : {
        "SRR606249_1_reads.fq.gz" :           "files.osf.io/v1/resources/dm938/providers/osfstorage/59f0f9156c613b026430dbc7",
        "SRR606249_2_reads.fq.gz" :           "files.osf.io/v1/resources/dm938/providers/osfstorage/59f0fc7fb83f69026076be47",
        "SRR606249_subset10_1_reads.fq.gz" :  "files.osf.io/v1/resources/dm938/providers/osfstorage/59f10134b83f69026377611b",
        "SRR606249_subset10_2_reads.fq.gz" :  "files.osf.io/v1/resources/dm938/providers/osfstorage/59f101f26c613b026330e53a",
        "SRR606249_subset25_1_reads.fq.gz" :  "files.osf.io/v1/resources/dm938/providers/osfstorage/59f1039a594d900263120c38",
        "SRR606249_subset25_2_reads.fq.gz" :  "files.osf.io/v1/resources/dm938/providers/osfstorage/59f104ed594d90026411f486",
        "SRR606249_subset50_1_reads.fq.gz" :  "files.osf.io/v1/resources/dm938/providers/osfstorage/59f1082d6c613b026430e5cf",
        "SRR606249_subset50_2_reads.fq.gz" :  "files.osf.io/v1/resources/dm938/providers/osfstorage/59f10ac6594d900262123e77",
    },

    "workflows" : {

        "taxonomic_classification_workflow" : {
            "sample"  : ["SRR606249_subset10","SRR606249_subset25"],
            "qual" : ["2","30"]
        },

        "taxonomic_classification_signatures_workflow" : {
            "sample"  : ["SRR606249_subset10","SRR606249_subset25"],
            "qual" : ["2","30"]
        },

        "taxonomic_classification_gather_workflow" : {
            "sample"  : ["SRR606249_subset10","SRR606249_subset25"],
            "qual" : ["2","30"],
            "kvalues" : ["21","31","51"]
        },

        "taxonomic_classification_kaijureport_workflow" : {
            "sample"  : ["SRR606249_subset10","SRR606249_subset25"],
            "qual" : ["2","30"]
        },

        "taxonomic_classification_kaijureport_filtered_workflow" : {
            "sample"  : ["SRR606249_subset10","SRR606249_subset25"],
            "qual" : ["2","30"]
        },

        "taxonomic_classification_kaijureport_filteredclass_workflow" : {
            "sample"  : ["SRR606249_subset10","SRR606249_subset25"],
            "qual" : ["2","30"]
        },
    }
}






both filtered reads and assemblies, and compare the computed signatures to 
a reference database.

Before you begin, make sure you have everything listed on the
[Installing](installing.md) page available on your command line.

Start by cloning the repository and moving to the `workflows/` directory:

```bash
git clone -b snakemake/comparison https://github.com/dahak-metagenomics/dahak
cd dahak/workflows/
```

Now create a JSON file that defines a Snakemake configuration dictionary.
This file should:

* Provide URLs at which each read filtering file can be accessed
* Provide a set of quality trimming values to use (2 and 30)
* Set all read filtering parameters (for simplicity, we will set each
    parameter to its default value)

(See the [Comparison Snakemake](comparison_snakemake.md) page for details on
these options.)

```json
{
    "files" : {
        "SRR606249_1_reads.fq.gz" :           "files.osf.io/v1/resources/dm938/providers/osfstorage/59f0f9156c613b026430dbc7",
        "SRR606249_2_reads.fq.gz" :           "files.osf.io/v1/resources/dm938/providers/osfstorage/59f0fc7fb83f69026076be47",
        "SRR606249_subset10_1_reads.fq.gz" :  "files.osf.io/v1/resources/dm938/providers/osfstorage/59f10134b83f69026377611b",
        "SRR606249_subset10_2_reads.fq.gz" :  "files.osf.io/v1/resources/dm938/providers/osfstorage/59f101f26c613b026330e53a",
        "SRR606249_subset25_1_reads.fq.gz" :  "files.osf.io/v1/resources/dm938/providers/osfstorage/59f1039a594d900263120c38",
        "SRR606249_subset25_2_reads.fq.gz" :  "files.osf.io/v1/resources/dm938/providers/osfstorage/59f104ed594d90026411f486"
    },

    "workflows" : {
        "comparison_workflow_reads_assembly" : {
            "kvalue"    : ["21","31","51"],
        }
    },

    "biocontainers" : {
        "sourmash_compare" : {
            "use_local" : false,
            "quayurl" : "quay.io/biocontainers/sourmash",
            "version" : "2.0.0a3--py36_0"
        }
    },

    "comparison" : {
        "compute_read_signatures" : {
            "scale"         : 10000,
            "kvalues"       : [21,31,51],
            "qual"          : ["2","30"],
            "sig_suffix"    : "_scaled10k.k21_31_51.sig", 
            "merge_suffix"  : "_scaled10k.k21_31_51.fq.gz"
        },
        "compute_assembly_signatures" : {
            "scale"         : 10000,
            "kvalues"       : [21,31,51],
            "qual"          : ["2","30"],
            "sig_suffix" : "_scaled10k.k21_31_51.sig",
            "merge_suffix"  : "_scaled10k.k21_31_51.fq.gz"
        },
        "compare_read_assembly_signatures" : {
            "samples"   : ["SRR606249_subset10"],
            "assembler" : ["megahit","metaspades"],
            "kvalues"   : [21, 31, 51],
            "csv_out"   : "SRR606249_trim2and30_ra_comparison.k{kvalue}.csv"
        }
    }
}
```

Note that there are two additional keys within the `comparison` configuration 
sub-dictionary, `compare_read_signatures` and `compare_assembly_signatures`,
but these sections are only used when comparing *just* reads (when passing the 
`comparison_workflow_reads` target to Snakemake) or when comparing *just*
assemblies (when passing the `comparison_workflow_assembly` target to Snakemake).

The JSON above can be put into the file `config/custom_comparison_workflow.json` 
(in the `workflows` directory of the repository), and the workflow can be run by
passing the config file to Snakemake. It is important you run with the `-n` flag
to do a dry-run first!

```bash
export SINGULARITY_BINDPATH="data:/data"

snakemake -p -n \
        --configfile=config/custom_comparison_workflow.json \
        comparison_workflow_reads_assembly

snakemake -p \
        --configfile=config/custom_comparison_workflow.json \
        comparison_workflow_reads_assembly
```



<br />
<br />
