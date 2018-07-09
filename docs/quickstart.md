# Quick Start

A flowchart illustrating how each workflow component fits 
together with tools into the overall process is included below:

![workflow flowchart](img/WorkflowFlowchartOriginal.png)


## Setting a Scratch Directory

To set the directory in which all files will be placed, set the `data_dir`
key in the Snakemake configuration dictionary. For example, if the following
Snakemake configuration dictionary is in `params/custom_scratch.settings`, 
it will put all intermediate files into the `data/` directory:

**`params/custom_scratch.settings`:**

```
{
    "data_dir" : "data"
}
```

This can be used by passing the `--configfile` flag to Snakemake:

```
$ snakemake --configfile=params/custom_scratch.settings ...
```


<br />
<br />


## Quick Start: Read Filtering

The read filtering workflow requires that the user specify
the following:

* List of read files and corresponding URLs;
* List of samples to run the read filtering workflow on;
* List of quality values to use when performing read filtering;
* Pre-trimming and post-trimming filename patterns;
* Adapter file name and URL

These can be specified in a configuration file in JSON format
as follows:

**`params/read_filtering_config.settings`:**

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
    --configfile=params/read_filtering_config.settings \
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

**`params/taxonomic_classification_config.settings`:**

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
    --configfile=params/taxonomic_classification_config.settings \
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


