# Quick Start

Note for the *very* impatient: skip straight to [The Really Quick Copy And Paste
Quick Start](#the-really-quick-copy-and-paste-quick-start) section.

## Getting Set Up to Run Workflows

**NOTE:** This guide assumes familiarity with Dahak workflows and how they work.
For a more clear explanation of what's going on and how things work, 
start with the [Running Workflows](running_workflows.md) page.

Start by cloning a copy of the repository:

```
$ git clone -b snakemake/comparison https://github.com/dahak-metagenomics/dahak
```

then move into the `workflows/` directory in the Dahak repository:

```
$ cd dahak/workflows/
```

The quick start assumes that all commands are run from the `workflows/` directory
unless stated otherwise.

As covered on the [Running Workflows](running_workflows.md) page, workflows are
run by using Snakemake from the command line. The basic syntax is:

```bash
$ snakemake [FLAGS] <target>
```

(See the [executing
Snakemake](https://snakemake.readthedocs.io/en/stable/executable.html#all-options)
page of the Snakemake documentation for a full list of options that can be used
with Snakemake.)

The most important flag to pass is the `--config` flag, which allows users to
specify a Snakemake configuration dictionary to customize their Dahak workflows.

The user should also pass the `--use-singularity` flag to tell Snakemake to use
Singularity containers. This also requires the `SINGULARITY_BINDPATH` variable
to be set, to bind-mount a local directory into the container. 

The user should use build targets. Each workflow's build targets and details
are listed on the respective workflow's Snakemake Rules" page.

All together, commands to run Dahak workflows will look like this:

```bash
$ SINGULARITY_BINDPATH="data:/data" \
        snakemake --use-singularity \
        [FLAGS] <target>
```


## Configuring Snakemake

See [Configuring Snakemake](config.md) for more details about Snakemake
configuration files. We cover the basics below.

### How do I specify my data files?

Specify the locations of your data files by assigning a key-value map
(keys are filenames, values are URLs) to the `files` key:

```
{
    "files" : {
        "SRR606249_1_reads.fq.gz" :           "files.osf.io/v1/resources/dm938/providers/osfstorage/59f0f9156c613b026430dbc7",
        "SRR606249_2_reads.fq.gz" :           "files.osf.io/v1/resources/dm938/providers/osfstorage/59f0fc7fb83f69026076be47",
        "SRR606249_subset10_1_reads.fq.gz" :  "files.osf.io/v1/resources/dm938/providers/osfstorage/59f10134b83f69026377611b",
        "SRR606249_subset10_2_reads.fq.gz" :  "files.osf.io/v1/resources/dm938/providers/osfstorage/59f101f26c613b026330e53a"
    }
}
```

This JSON can be put into a JSON file like `config/custom_readfilt.json` and
passed to Snakemake via the `--configfile` flag:

```
$ SINGULARITY_BINDPATH="data:/data" \
        snakemake --configfile=config/custom_datafiles.json \
        [FLAGS] <target>
```

If your read files are present locally, they must be in the same
directory as the Snakemake working directory, which is specified by
the `data_dir` key (`data/` by default).

!!! warning "Examples in the Repository"

    Also see [`workflows/config/example_datafiles.json`](#)
    in the Dahak repository, as well as the "Snakemake" page 
    for each respective workflow.


### How do I specify my workflow configuration?

The workflow configuration is the section of the Snakemake configuration file
where you specify any information that will end up in the final file name of the
file that the workflow generates. This is generally a small number of parameters.

Each workflow has different build rules requiring different information.
See the "Snakemake Rules" page for a list of available build rules.
See the "Snakemake Configuration" page for a list of key-value pairs the
build rule extracts from the Snakemake configuration dictionary.

For example, to evaluate the quality of reads from a sequencer after quality
trimming, the `read_filtering_posttrim_workflow` Snakemake rule is used, and the
workflow configuration JSON looks like this:

```
{
    "workflows" : {
        "read_filtering_posttrim_workflow" : {
            "sample"    : ["SRR606249","SRR606249_subset10"],
            "qual"   : ["2","30"]
        },
    }
}
```

This file can be put into a JSON file like `config/custom_workflowconfig.json` and
passed to Snakemake via the `--configfile` flag:

```
$ SINGULARITY_BINDPATH="data:/data" \
        snakemake --configfile=config/custom_readfilt.json \
        [FLAGS] read_filtering_posttrim_workflow
```

The `sample` list specifies the prefixes of the sample reads to 
run the read filtering workflow on. The `qual` list specifies the 
values to use for quality trimming.

!!! warning "Examples in the Repository"

    Also see [workflows/config/example_workflowconfig.json](#)
    in the Dahak repository, as well as the "Snakemake" page 
    for each respective workflow.


## How do I specify my workflow parameters?

The workflow parameters section of the Snakemake configuration file
is where the details of each step of the workflow can be controlled.

The **workflow configuration** section of the Snakemake configuration dictionary
contains a subset of parameters that will end up in the final file name of the
output file generated by that workflow.  

The **workflow parameters** section of the Snakemake configuration dictionary
contains all other parameters for all intermediate steps, and is therefore
longer and contains more options than the workflow configuration section.

The workflow parameters are organized by workflow, with one additional
parameters section for setting the version and URL of the biocontainers 
used in each workflow.

For example, the read filtering workflow parameters section 
is under the top-level `read_filtering` key:

```
{
    "read_filtering" : {
        "read_patterns" : {
            "pre_trimming_pattern"  : "{sample}_{direction}_reads.fq.gz",
            "post_trimming_pattern" : "{sample}_{direction}.trim{qual}.fq.gz",
        },
        "direction_labels" : {
            "forward" : "1",
            "reverse" : "2"
        },
        "quality_assessment" : {
            "fastqc_suffix": "fastqc",
        },
        "quality_trimming" : {
            "trim_suffix" : "se"
        },
        "interleaving" : {
            "interleave_suffix" : "pe"
        },
        "adapter_file" : {
            "name" : "TruSeq2-PE.fa",
            "url"  : "http://dib-training.ucdavis.edu.s3.amazonaws.com/mRNAseq-semi-2015-03-04/TruSeq2-PE.fa"
        }
    }
}
```

This file can be put into a JSON file like `config/custom_readfilt.json` and
passed to Snakemake via the `--configfile` flag:

```
$ SINGULARITY_BINDPATH="data:/data" \
        snakemake --configfile=config/custom_readfilt.json \
        [FLAGS] read_filtering_posttrim_workflow
```

(See the [Read Filtering Snakemake](readfilt_snakemake.md) page
for an explanation of each of the above options.)

!!! warning "Examples in the Repository"
    
    The [`workflows/config/example_workflowparams.json`](#)
    file in the repository contains an example, but JSON files
    do not contain any comments. For a well-commented version,
    check the `workflows/config/default_workflowparams.settings](#)
    file.
    
## Where will data files live?

To set the scratch/working directory for the Snakemake workflows, 
in which all intermediate and final data files will be placed, 
set the `data_dir` key in the Snakemake configuration dictionary. 
If this option is not set, it will be `data` by default.  No 
trailing slash is needed when setting this option.

!!! warning "Important Note About `data_dir`"

    If you use a custom directory, you must also 
    adjust the `SINGULARITY_BINDPATH` variable accordingly.

For example, to put all intermediate files into the `work/` directory
instead of the `data/` directory, you can use the following JSON
file:

```
{
    "data_dir" : "work"
}
```

This file can be put into a JSON file like `config/custom_datadir.json` and
passed to Snakemake via the `--configfile` flag:

```
$ SINGULARITY_BINDPATH="work:/work" \
        snakemake --configfile=config/custom_datadir.settings \
        [FLAGS] <target>
```

<br />
<br />

## The Really Quick Copy-And-Paste Quick Start

Now that we've provided some examples that you can use, let's run through
the entire process start to finish to illustrate how this works.

### Read Filtering

We will run two variations of the read filtering workflow, and perform a quality
assessment of our reads both before and after quality trimming.

Before you begin, make sure you have everything listed on the
[Installing](installing.md) page available on your command line.

Start by cloning a copy of the repository:

```
$ git clone -b snakemake/comparison https://github.com/dahak-metagenomics/dahak
```

then move into the `workflows/` directory of the Dahak repository:

```
$ cd dahak/workflows/
```

Now create a configuration JSON file that:

* Provides URLs at which each read filtering file can be accessed
* Provides a set of quality trimming values to use (2 and 30)
* Sets all read filtering parameters (for simplicity, we will set each
    parameter to its default value)
 
```
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
        "read_filtering_pretrim_workflow" : {
            "sample"    : ["SRR606249_subset25","SRR606249_subset10"],
        },
        "read_filtering_posttrim_workflow" : {
            "sample"    : ["SRR606249_subset25","SRR606249_subset10"],
            "qual"   : ["2","30"]
        },
    },

    "read_filtering" : {
        "read_patterns" : {
            "pre_trimming_pattern"  : "{sample}_{direction}_reads.fq.gz",
            "post_trimming_pattern" : "{sample}_{direction}.trim{qual}.fq.gz",
        },
        "direction_labels" : {
            "forward" : "1",
            "reverse" : "2"
        },
        "quality_assessment" : {
            "fastqc_suffix": "fastqc",
        },
        "quality_trimming" : {
            "trim_suffix" : "se"
        },
        "interleaving" : {
            "interleave_suffix" : "pe"
        },
        "adapter_file" : {
            "name" : "TruSeq2-PE.fa",
            "url"  : "http://dib-training.ucdavis.edu.s3.amazonaws.com/mRNAseq-semi-2015-03-04/TruSeq2-PE.fa"
        }
    }
}
```

Put this file into `config/custom_readfilt_workflow.json` (in the `workflows`
directory of the repository). We want to run two workflows: one pre-trimming
quality assessment, and one post-trimming quality assessment, so we call
Snakemake and pass it two build targets: `read_filtering_pretrim_workflow`
and `read_filtering_posttrim_workflow`.

We add two flags to the Snakemake command: `-n` and `-p`.

`-n` does a *dry-run*, meaning Snakemake will print out what tasks it is
going to run, but will not acutally run them.

`-p` tells Snakemake to print the shell commands that it will run for each
workflow step. This is useful for understanding what Snakemake is doing
and what commands and options are being run.

```
$ export SINGULARITY_BINDPATH="data:/data"

$ snakemake -p -n \
        --configfile=config/custom_readfilt_workflow.json \
        read_filtering_pretrim_workflow

$ snakemake -p -n \
        --configfile=config/custom_readfilt_workflow.json \
        read_filtering_posttrim_workflow
```

Once we have reviewed the output from Snakemake and are satisfied
it is running the correct workflow and commands, we can actually
run the workflow by removing the `-n` flag: 

```
$ export SINGULARITY_BINDPATH="data:/data" 

$ snakemake -p \
        --configfile=config/custom_readfilt_workflow.json \
        read_filtering_pretrim_workflow

$ snakemake -p \
        --configfile=config/custom_readfilt_workflow.json \
        read_filtering_posttrim_workflow
```

We can also run both workflows at once by specifying two targets:

```
$ snakemake -p \
        --configfile=config/custom_readfilt_workflow.json \
        read_filtering_pretrim_workflow read_filtering_posttrim_workflow
```

<br />
<br />

### Assembly

We will run two assembler workflows using the two assemblers
implemented in Dahak, SPAdes and Megahit.

Before you begin, make sure you have everything listed on the
[Installing](installing.md) page available on your command line.

If you have not already, clone a copy of the repository and move
to the `workflows/` directory:

```
$ git clone -b snakemake/comparison https://github.com/dahak-metagenomics/dahak
$ cd dahak/workflows/
```

Now create a configuration JSON file that:

* Provides URLs at which each read filtering file can be accessed
* Provides a set of 
* Sets all read filtering parameters (for simplicity, we will set each
    parameter to its default value)


```
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
        "assembly_workflow_all" : {
            "sample"    : ["SRR606249_subset10","SRR606249_subset25"],
            "qual"      : ["2","30"],
        }
    },

    "assembly" : {
        "assembly_patterns" : {
            "metaspades_pattern" : "{sample}.trim{qual}_metaspades.contigs.fa",
            "megahit_pattern" : "{sample}.trim{qual}_megahit.contigs.fa",
            "assembly_pattern" : "{sample}.trim{qual}_{assembler}.contigs.fa",
            "quast_pattern" : "{sample}.trim{qual}_{assembler}_quast/report.html",
            "multiqc_pattern" : "{sample}.trim{qual}_{assembler}_multiqc/report.html",
        }
    },

}
```

Put this file into `config/custom_assembly_workflow.json` (in the `workflows`
directory of the repository). We want to run the assembly workflow with
two assemblers, so we call Snakemake and the `assembly_workflow_all` target.

```
$ export SINGULARITY_BINDPATH="data:/data"

$ snakemake -p -n \
        --configfile=config/custom_assembly_workflow.json \
        assembly_workflow_all
```

Once we have reviewed the output from Snakemake and are satisfied
it is running the correct workflow and commands, we can actually
run the workflow by removing the `-n` flag: 

```
$ export SINGULARITY_BINDPATH="data:/data"

$ snakemake -p \
        --configfile=config/custom_assembly_workflow.json \
        assembly_workflow_all
```

<br />
<br />



