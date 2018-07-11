# Read Filtering Workflow: Snakemake

As mentioned on the [Running Workflows](running_workflows.md) page,
the Snakemake workflows define **build rules** that trigger all of
the rules composing a given workflow.

As a reminder, the [Running Workflows](running_workflows.md) page 
showed how to call Snakemake and ask for a particular target:

```bash
snakemake [FLAGS] <target>
```

You can replace `<target>` with any of the build rules below.

## Build Rules

The build rules are the rules that the end user should be calling.
A list of available build rules in the read filtering workflow is
given below.

```
read_filtering_pretrim_workflow
    
    Build rule: trigger the read filtering workflow
    
read_filtering_posttrim_workflow
    
    Build rule: trigger the read filtering workflow
    
```

Pass the name of the build rule directly to Snakemake
on the command line:

```bash
snakemake [FLAGS] read_filtering_pretrim_workflow read_filtering_posttrim_workflow
```

See the [Quick Start](quickstart.md) for details on the process of running this workflow.


## Snakemake Configuration Dictionary

There are three types of key-value pairs that can be set in the 
Snakemake configuration dictionary (also see the 
[Workflow Configuration](config.md) page).

### Data Files Configuration

Set the `files` key to a dictionary containing
a list of key-value pairs, where the keys are 
filenames and values are URLs:

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

Put these in a JSON file (e.g., `config/custom_datafiles.json` 
in the `workflows` directory) and pass the name of the config file
to Snakemake using the `--configfile` flag:

```bash
snakemake --configfile=config/custom_datafiles.json [FLAGS] <target>
```

### Workflow Configuration

Set the `workflows` key of the Snakemake configuration dictionary to a
dictionary containing details about the workflow you want to run.  The workflow
configuration values are values that will end up in the final output file's
filename.

Here is the structure of the configuration dictionary
for read filtering workflows (pre-trimming and post-trimming
quality assessment):

```json
{
    "workflows" : {

        "read_filtering_pretrim_workflow" : {
            "sample"    : ["SRR606249_subset10","SRR606249_subset25"]
        },

        "read_filtering_posttrim_workflow" : {
            "sample"    : ["SRR606249_subset10","SRR606249_subset25"],
            "qual"   : ["2","30"]
        }
    }
}
```

The `sample` list specifies the prefixes of the sample reads to 
run the read filtering workflow on. The `qual` list specifies the 
values to use for quality trimming (for the post-trimming workflow).

Put these in a JSON file (e.g., `config/custom_workflowconfig.json` 
in the `workflows` directory) and pass the name of the config file
to Snakemake using the `--configfile` flag:

```bash
snakemake --configfile=config/custom_workflowconfig.json [FLAGS] <target>
```

### Workflow Parameters

Set the `read_filtering` key of the Snakemake configuration dictionary
to a dictionary containing various child dictionaries and key-value pairs:

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

The `pre_trimming_pattern` must match the filename pattern of the reads 
that are provided in the `files` key. The `{sample}` and `{direction}`
notation is for Snakemake to match wildcards. For example, the pattern

```
    {sample}_{direction}_reads.fq.gz
```

will match the filename

```
    SRR606249_subset10_1_reads.fq.gz
```

such that the wildcard values are `sample=SRR606249_subset10`
and `direction=1`.

The `direction_labels` key is used to indicate the suffix used for
forward and reverse reads; this is typically `1` and `2` but can be
customized by the user if needed.

To use custom values for these parameters, put the configuration dictionary
above (or any subset of it) into a JSON file (e.g.,
`config/custom_workflowparams.json` in the `workflows` directory) and pass the
name of the config file to Snakemake using the `--configfile` flag:

```bash
snakemake --configfile=config/custom_workflowparams.json [FLAGS] <target>
```


