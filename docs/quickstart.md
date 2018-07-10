# Quick Start

## Getting Set Up to Run Workflows

**NOTE:** This guide assumes familiarity with Dahak workflows and how they work.
For a more clear explanation of what's going on and how things work, see the 
start with the [Running Workflows](running_workflows.md) page.

Start by cloning a copy of the repository:

```
$ git clone https://github.com/dahak-metagenomics/dahak
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
are listed on the respective workflow's Snakkemake Rules" page.

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
        "SRR606249_subset10_2_reads.fq.gz" :  "files.osf.io/v1/resources/dm938/providers/osfstorage/59f101f26c613b026330e53a",
        "SRR606249_subset25_1_reads.fq.gz" :  "files.osf.io/v1/resources/dm938/providers/osfstorage/59f1039a594d900263120c38",
        "SRR606249_subset25_2_reads.fq.gz" :  "files.osf.io/v1/resources/dm938/providers/osfstorage/59f104ed594d90026411f486",
        "SRR606249_subset50_1_reads.fq.gz" :  "files.osf.io/v1/resources/dm938/providers/osfstorage/59f1082d6c613b026430e5cf",
        "SRR606249_subset50_2_reads.fq.gz" :  "files.osf.io/v1/resources/dm938/providers/osfstorage/59f10ac6594d900262123e77",
    }
}
```

If your read files are present locally, they must be in the same
directory as the Snakemake working directory, which is specified by
the `data_dir` key.

!!! warning "Example"

    Also see [workflows/config/example_datafiles.json](#)
    in the Dahak repository.


### How do I specify my workflow configuration?

The workflow configuration is the section of the Snakemake configuration file
where you specify any information that will end up in the final file name of the
file that the workflow generates. This is generally a small number of parameters.

Each workflow has different build rules requiring different information.
See the "Snakemake Rules" page for a list of available build rules.
See the "Snakemake Configuration" page for a list of key-value pairs the
build rule extracts from the Snakemake configuration dictionary.

For example, to evaluate the quality of reads from a sequencer before
quality trimming, we can configure the `read_filtering_pretrim_workflow`
Snakemake rule is used, and the workflow configuration JSON looks like this:

```
{
    "workflows" : {
        "read_filtering_pretrim_workflow" : {
            "sample"    : ["SRR606249_subset10","SRR606249_subset25"]
        }
    }
}
```

To evaluate the quality of reads from a sequencer after quality trimming, the
`read_filtering_posttrim_workflow` Snakemake rule is used, and the workflow
configuration JSON looks like this:

```
{
    "workflows" : {
        "read_filtering_posttrim_workflow" : {
            "sample"    : ["SRR606249_subset10","SRR606249_subset25"],
            "qual"   : ["2","30"]
        },
    }
}
```



The `sample` list specifies the prefixes of the sample reads to 
run the read filtering workflow on.



!!! warning "Example"

    Also see [workflows/config/example_workflowconfig.json](#)
    in the Dahak repository.


## How do I specify my workflow parameters?




!!! warning "Example"

    Also see [workflows/config/example_datafiles.json](#)
    in the Dahak repository.








## How do I specify workflow parameters?

See the [Running Workflows](running_workflows.md) and 
[Snakemake Configuration](config.md) pages for details.


## What targets do I use?

See [Running Workflows](running_workflows.md)

## Where will data files live?

To set the scratch/working directory for the Snakemake workflows, 
in which all intermediate and final data files will be placed, 
set the `data_dir` key in the Snakemake configuration dictionary. 
If this option is not set, it will be `data` by default.

**IMPORTANT:** If you use a custom directory, you must also 
adjust the `SINGULARITY_BINDPATH` variable accordingly.

**NOTE:** No trailing slash is needed.

For example, to put all intermediate files into the `work/` directory
instead of the `data/` directory, you can use the following JSON
file:

```
{
    "data_dir" : "work"
}
```

This can be used by passing the `--configfile` flag to Snakemake
and updating the Singularity environment variable:

```
$ SINGULARITY_BINDPATH="work:/work" \
        snakemake --configfile=config/custom_scratch.settings \
        [FLAGS] <target>
```


## How do I specify which samples to run the workflow on?

Each workflow has a set of build rules that will trigger all other rules
required to run a workflow. These build rules require the user to specify
which read files to begin with. We cover several examples below.

<br />
<br />

## Quick Start: Read Filtering

To run the read filtering workflow, there are several workflow configuration
options and workflow parameter values that the user should set.

The user must start by specifying the location of their read files as covered in
the "How do I specify my data files?" section above.

Workflow configuration options the user must specify:

* List of samples to run the read filtering workflow on
* List of quality values to use when performing read filtering

Workflow parameters the user should specify:

* Pre-trimming and post-trimming filename patterns

The read filtering workflow requires that the user specify
the following:

* List of read files and corresponding URLs;
* List of quality values to use when performing read filtering;
* Pre-trimming and post-trimming filename patterns;
* Adapter file name and URL

These can be specified in a configuration file in JSON format
as follows:

**`config/read_filtering_config.settings`:**

```
{
    #
    # Specify where to get the read files
    # 
    "files" : {
        #
        # URLs for full and subsampled reads
        # these must match the pre_trimming pattern given below
        "SRR606249_1_reads.fq.gz" :           "files.osf.io/v1/resources/dm938/providers/osfstorage/59f0f9156c613b026430dbc7",
        "SRR606249_2_reads.fq.gz" :           "files.osf.io/v1/resources/dm938/providers/osfstorage/59f0fc7fb83f69026076be47",
        "SRR606249_subset10_1_reads.fq.gz" :  "files.osf.io/v1/resources/dm938/providers/osfstorage/59f10134b83f69026377611b",
        "SRR606249_subset10_2_reads.fq.gz" :  "files.osf.io/v1/resources/dm938/providers/osfstorage/59f101f26c613b026330e53a",
        "SRR606249_subset25_1_reads.fq.gz" :  "files.osf.io/v1/resources/dm938/providers/osfstorage/59f1039a594d900263120c38",
        "SRR606249_subset25_2_reads.fq.gz" :  "files.osf.io/v1/resources/dm938/providers/osfstorage/59f104ed594d90026411f486",
        "SRR606249_subset50_1_reads.fq.gz" :  "files.osf.io/v1/resources/dm938/providers/osfstorage/59f1082d6c613b026430e5cf",
        "SRR606249_subset50_2_reads.fq.gz" :  "files.osf.io/v1/resources/dm938/providers/osfstorage/59f10ac6594d900262123e77",
    },


    #
    # Specify how to do read filtering
    # 
    "read_filtering" : {
        # 
        # The workflow actually builds the rules to download 
        # the read_files by using the pre_trimming_pattern.
        "read_patterns" : {
            #
            # filename pattern for pre-trimmed reads
            # Note: the files section (top) listing URLS for read files
            # MUST match the pre_trimmming_pattern.
            "pre_trimming_pattern"  : "{sample}_{direction}_reads.fq.gz",
            #
            # filename pattern for post-trimmed reads
            "post_trimming_pattern" : "{sample}_{direction}.trim{qual}.fq.gz",
        },
        #
        # Set the read adapter file
        "adapter_file" : {
            # 
            # name and URL for the sequencer adapter file
            "name" : "TruSeq2-PE.fa",
            "url"  : "http://dib-training.ucdavis.edu.s3.amazonaws.com/mRNAseq-semi-2015-03-04/TruSeq2-PE.fa"
        }
    },


    #
    # Specify what reads to filter
    # 
    "workflows" : {

        "read_filtering_workflow" : {
            #
            # These parameters determine which samples
            # the read filtering workflow will be run on.
            "sample"    : ["SRR606249_subset10","SRR606249_subset25"],
            "direction" : ["1","2"],
            "quality"   : ["2","30"],
        }
    }
}
```

To run the read filtering workflow, call snakemake and pass the
`read_filtering_workflow` build rule:

```
$ SINGULARITY_BINDPATH="data:/data" \
    snakemake \
    --use-singularity \
    --configfile=config/read_filtering_config.settings \
    read_filtering_workflow
``` 

When this command is run, it uses the filename pattern for the 
post-trimming step to construct filenames resulting from the
read filtering step, and asks Snakemake to run the rules that
produce those files.

More information about the read filtering workflow:

* [Read Filtering Walkthrough](readfilt_walkthru.md)
* [Read Filtering Snakemake Rules](readfilt_snakemake.md)
* [Read Filtering Parameters and Configuration](readfilt_config.md)


<br />
<br />


## Quick Start: Taxonomic Classification

The taxonomic classification workflow builds on the read filtering
workflow, so the user should specify all of the information
listed in the "Quick Start: Read Filtering" section (above). 
In addition, the user should specify the following:

* Percent threshold to use for taxa filtering
* Taxonomic rank to use for kaiju2krona
* Kaiju database name and URL

These can be specified in a configuration file in JSON format
as follows:

**`config/taxonomic_classification_config.settings`:**

```
{
    #
    # Specify where to get the read files
    # 
    "files" : {
        #
        # URLs for full and subsampled reads
        # these must match the pre_trimming pattern given below
        "SRR606249_1_reads.fq.gz" :           "files.osf.io/v1/resources/dm938/providers/osfstorage/59f0f9156c613b026430dbc7",
        "SRR606249_2_reads.fq.gz" :           "files.osf.io/v1/resources/dm938/providers/osfstorage/59f0fc7fb83f69026076be47",
        "SRR606249_subset10_1_reads.fq.gz" :  "files.osf.io/v1/resources/dm938/providers/osfstorage/59f10134b83f69026377611b",
        "SRR606249_subset10_2_reads.fq.gz" :  "files.osf.io/v1/resources/dm938/providers/osfstorage/59f101f26c613b026330e53a",
        "SRR606249_subset25_1_reads.fq.gz" :  "files.osf.io/v1/resources/dm938/providers/osfstorage/59f1039a594d900263120c38",
        "SRR606249_subset25_2_reads.fq.gz" :  "files.osf.io/v1/resources/dm938/providers/osfstorage/59f104ed594d90026411f486",
        "SRR606249_subset50_1_reads.fq.gz" :  "files.osf.io/v1/resources/dm938/providers/osfstorage/59f1082d6c613b026430e5cf",
        "SRR606249_subset50_2_reads.fq.gz" :  "files.osf.io/v1/resources/dm938/providers/osfstorage/59f10ac6594d900262123e77",
    },


    #
    # Specify how to do taxonomic classification
    # 
    "taxonomic_classification" : {

        "filter_taxa" : {
            #
            # percent threshold for taxa filtering
            "pct_threshold" : 1
        },

        "kaiju2krona" : {
            #
            # specify the taxonomic rank for kaiju2krona to use
            "taxonomic_rank" : "genus"
        },

        "kaiju" : {
            "dmp1" : "nodes.dmp",
            "dmp2" : "names.dmp",
            "fmi"  : "kaiju_db_nr_euk.fmi",
            "tar"  : "kaiju_index_nr_euk.tgz",
            #"url"  : "https://s3.amazonaws.com/dahak-project-ucdavis/kaiju",
            "url"  : "http://kaiju.binf.ku.dk/database",
            "out"  : "{sample}.kaiju_output.trim{qual}.out"
        },

        "reads" : {
            # set filename pattern for reads
            "fq_fwd" : "{sample}_1.trim{qual}.fq.gz",
            "fq_rev" : "{sample}_2.trim{qual}.fq.gz"
        },

        "sourmash" : { 
            #
            # URL base for SBT tree
            "sbturl"  : "s3-us-west-1.amazonaws.com/spacegraphcats.ucdavis.edu",
            # 
            # name of SBT tar file
            "sbttar"  : "microbe-{database}-sbt-k{ksize}-2017.05.09.tar.gz",
            #
            # name of SBT file when unpacked
            "sbtunpack" : "{database}-k{ksize}.sbt.json"
        },

        "visualize_krona" : {
            #
            # .summary will be replaced with .html for the final report
            "input_summary"  : "{sample}.kaiju_output.trim{qual}.summary",
        }
    },


    ###########################################
    # Everything below this line is the same
    # as the read filtering example above.
    ###########################################


    #
    # Specify how to do read filtering
    # 
    "read_filtering" : {
        # 
        # The workflow actually builds the rules to download 
        # the read_files by using the pre_trimming_pattern.
        "read_patterns" : {
            #
            # filename pattern for pre-trimmed reads
            # Note: the files section (top) listing URLS for read files
            # MUST match the pre_trimmming_pattern.
            "pre_trimming_pattern"  : "{sample}_{direction}_reads.fq.gz",
            #
            # filename pattern for post-trimmed reads
            "post_trimming_pattern" : "{sample}_{direction}.trim{qual}.fq.gz",
        },
        #
        # Set the read adapter file
        "adapter_file" : {
            # 
            # name and URL for the sequencer adapter file
            "name" : "TruSeq2-PE.fa",
            "url"  : "http://dib-training.ucdavis.edu.s3.amazonaws.com/mRNAseq-semi-2015-03-04/TruSeq2-PE.fa"
        }
    },


    #
    # Specify what reads to filter
    # 
    "workflows" : {

        "read_filtering_workflow" : {
            #
            # These parameters determine which samples
            # the read filtering workflow will be run on.
            "sample"    : ["SRR606249_subset10","SRR606249_subset25"],
            "direction" : ["1","2"],
            "quality"   : ["2","30"],
        }
    }
}
```

To run the read filtering workflow, call snakemake and pass the
`taxonomic_classification_workflow` build rule:

```
$ SINGULARITY_BINDPATH="data:/data" \
    snakemake \
    --use-singularity \
    --configfile=config/taxonomic_classification_config.settings \
    taxonomic_classification_workflow
``` 

More information about the taxonomic classification workflow:

* [Taxonomic Classification Walkthrough](taxclass_walkthru.md)
* [Taxonomic Classification Snakemake Rules](taxclass_snakemake.md)
* [Taxonomic Classification Parameters and Configuration](taxclass_config.md)


<br />
<br />


## Quick Start: Assembly

More information about the assembly workflow:

* [Assembly Walkthrough](assembly_walkthru.md)
* [Assembly Snakemake Rules](assembly_snakemake.md)
* [Assembly Parameters and Configuration](assembly_config.md)


<br />
<br />


## Quick Start: Comparison

More information about the workflow:

* [Comparison Walkthrough](comparison_walkthru.md)
* [Comparison Snakemake Rules](comparison_snakemake.md)
* [Comparison Parameters and Configuration](comparison_config.md)


