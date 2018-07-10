# Comparison: Snakemake

As mentioned on the [Running Workflows](running_workflows.md) page,
the Snakemake workflows define **build rules** that trigger all of
the rules composing a given workflow.

As a reminder, the [Running Workflows](running_workflows.md) page 
showed how to call Snakemake and ask for a particular target:

```
$ snakemake [FLAGS] <target>
```

## Build Rules

The build rules are the rules that the end user should be calling.
A list of available build rules in the taxonomic classification 
workflow is given below.

List of available build rules in the comparison workflow:

```
comparison_workflow_reads
    
    Build rule: run sourmash compare on all reads
    
comparison_workflow_assembly
    
    Build rule: run sourmash compare on all assemblies
    
comparison_workflow_reads_assembly
    
    Build rule: run sourmash compare on all reads and assemblies together
```  

Pass the name of the build rule directly to Snakemake
on the command line:

```
$ snakemake [FLAGS] comparison_workflow_reads \
        comparison_workflow_assembly \
        comparison_workflow_reads_assembly
```

See below for how to configure these workflows.  See the [Quick
Start](quickstart.md) for details on the process of running this workflow.


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

```
$ snakemake --configfile=config/custom_datafiles.json [FLAGS] <target>
```

### Workflow Configuration

Set the `workflows` key of the Snakemake configuration dictionary to a
dictionary containing details about the workflow you want to run.  The workflow
configuration values are values that will end up in the final output file's
filename.

Here is the structure of the configuration dictionary
for taxonomic classification workflows:

```
{
    "workflows" : {
        "comparison_workflow_reads": {
            #
            # these parameters determine which reads
            # the comparison workflow will be run on
            # 
            "kvalue"    : ["21","31","51"],
        },

        "comparison_workflow_assembly" : {
            #
            # these parameters determine which assembled reads
            # the comparison workflow will be run on
            # 
            "kvalue"    : ["21","31","51"],
        },

        "comparison_workflow_reads_assembly" : {
            #
            # these parameters determine which reads and assembled 
            # reads the comparison workflow will be run on
            # 
            "kvalue"    : ["21","31","51"],
        }
    }
}
```

Put these in a JSON file (e.g., `config/custom_workflowconfig.json` 
in the `workflows` directory) and pass the name of the config file
to Snakemake using the `--configfile` flag:

```
$ snakemake --configfile=config/custom_workflowconfig.json [FLAGS] <target>
```

### Workflow Parameters

Set the `taxonomic_classification` key of the Snakemake configuration dictionary
as shown below:

```
{
    "comparison" : {
        "compute_read_signatures" : {
            "scale"         : 10000,
            "kvalues"       : [21,31,51],
            "qual"          : ["2","30"],
            "sig_suffix"    : "_scaled10k.k21_31_51.sig", 
            "merge_suffix"  : "_scaled10k.k21_31_51.fq.gz"
        },
        "compare_read_signatures" : {
            "kvalues" : [21, 31, 51],
            "samples" : ["SRR606249_subset10","SRR606249_subset25"],
            "csv_out" : "SRR606249allsamples_trim2and30_read_comparison.k{kvalue}.csv"
        },
        "compute_assembly_signatures" : {
            "scale"         : 10000,
            "kvalues"       : [21,31,51],
            "qual"          : ["2","30"],
            "sig_suffix" : "_scaled10k.k21_31_51.sig",
            "merge_suffix"  : "_scaled10k.k21_31_51.fq.gz"
        },
        "compare_assembly_signatures" : {
            "kvalues"   : [21, 31, 51],
            "samples"   : ["SRR606249_subset10","SRR606249_subset25"],
            "assembler" : ["megahit","metaspades"],
            "csv_out"   : "SRR606249_trim2and30_assembly_comparison.k{kvalue}.csv"
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

Put these in a JSON file (e.g., `config/custom_workflowparams.json` 
in the `workflows` directory) and pass the name of the config file
to Snakemake using the `--configfile` flag:

```
$ snakemake --configfile=config/custom_workflowparams.json [FLAGS] <target>
```

