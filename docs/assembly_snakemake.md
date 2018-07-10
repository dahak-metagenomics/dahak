# Assembly: Snakemake

As mentioned on the [Running Workflows](running_workflows.md) page,
the Snakemake workflows define **build rules** that trigger all of
the rules composing a given workflow.

As a reminder, the [Running Workflows](running_workflows.md) page 
showed how to call Snakemake and ask for a particular target:

```
$ snakemake [FLAGS] <target>
```

You can replace `<target>` with any of the build rules below.

## Build Rules

The build rules are the rules that the end user should be calling.
A list of available build rules in the assembly workflow is
given below.

```
assembly_workflow_metaspades
    
    Build rule: trigger the metaspades assembly step.
    
assembly_workflow_megahit
    
    Build rule: trigger the megahit assembly step.
    
assembly_workflow_all
    
    Build rule: trigger the assembly step with all assemblers.
    
```

Pass the name of the build rule directly to Snakemake
on the command line:

```
$ snakemake [FLAGS] assembly_workflow_all
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
for assembly workflows:

```
{
    "workflows" : {
        "assembly_workflow_metaspades" : {
            "sample"    : ["SRR606249_subset10","SRR606249_subset25"],
            "qual"      : ["2","30"],
        },

        "assembly_workflow_megahit" : {
            "sample"    : ["SRR606249_subset10","SRR606249_subset25"],
            "qual"      : ["2","30"],
        },

        "assembly_workflow_all" : {
            "sample"    : ["SRR606249_subset10","SRR606249_subset25"],
            "qual"      : ["2","30"],
        },

    }
}
```

The `sample` and `qual` keys are used by Snakemake to generate a list of
input files required for the rule, and to generate the name of the output
file from the workflow. These should be lists of strings. `sample` should
match the read files listed in the `files` section, while `qual` should be 
the quality trimming value to use.

Put these in a JSON file (e.g., `config/custom_workflowconfig.json` 
in the `workflows` directory) and pass the name of the config file
to Snakemake using the `--configfile` flag:

```
$ snakemake --configfile=config/custom_workflowconfig.json [FLAGS] <target>
```


### Workflow Parameters

Set the `assembly` key of the Snakemake configuration dictionary
as shown below:

```
{
    "assembly" : {
        "assembly_patterns" : {
            "metaspades_pattern" : "{sample}.trim{qual}_metaspades.contigs.fa",
            "megahit_pattern" : "{sample}.trim{qual}_megahit.contigs.fa",
            "assembly_pattern" : "{sample}.trim{qual}_{assembler}.contigs.fa",
            "quast_pattern" : "{sample}.trim{qual}_{assembler}_quast/report.html",
            "multiqc_pattern" : "{sample}.trim{qual}_{assembler}_multiqc/report.html",
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

