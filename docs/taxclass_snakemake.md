# Taxonomic Classification: Snakemake

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
A list of available build rules in the taxonomic classification 
workflow is given below.

```
taxonomic_classification_signatures_workflow
    
    Build rule: trigger calculation of signatures from reads.

taxonomic_classification_gather_workflow

    Gather and compare read signatures using sourmash gather

taxonomic_classification_kaijureport_workflow

    Run kaiju and generate a report from all results.

taxonomic_classification_kaijureport_filtered_workflow

    Run kaiju and generate a report from filtered
    results (taxa with <X% abundance).

taxonomic_classification_kaijureport_filteredclass_workflow

    Run kaiju and generate a report from filtered, classified
    results (taxa with <X% abundance).
    
```

Pass the name of the build rule directly to Snakemake
on the command line:

```bash
snakemake [FLAGS] taxonomic_classification_kaijureport_workflow \
        taxonomic_classification_kaijureport_filtered_workflow \
        taxonomic_classification_kaijureport_filteredclass_workflow 
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

```json
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
for taxonomic classification workflows:

```json
{
    "workflows" : {
        "taxonomic_classification_workflow" : {
            "sample"  : ["SRR606249_subset10","SRR606249_subset25"],
            "qual" : ["2","30"],
        },

        "taxonomic_classification_signatures_workflow" : {
            "sample"  : ["SRR606249_subset10","SRR606249_subset25"],
            "qual" : ["2","30"],
        },

        "taxonomic_classification_gather_workflow" : {
            "sample"  : ["SRR606249_subset10","SRR606249_subset25"],
            "qual" : ["2","30"],
            "kvalues" : ["21","31","51"]
        },

        "taxonomic_classification_kaijureport_workflow" : {
            "sample"  : ["SRR606249_subset10","SRR606249_subset25"],
            "qual" : ["2","30"],
        },

        "taxonomic_classification_kaijureport_filtered_workflow" : {
            "sample"  : ["SRR606249_subset10","SRR606249_subset25"],
            "qual" : ["2","30"],
        },

        "taxonomic_classification_kaijureport_filteredclass_workflow" : {
            "sample"  : ["SRR606249_subset10","SRR606249_subset25"],
            "qual" : ["2","30"],
        }
    }
}
```

Put these in a JSON file (e.g., `config/custom_workflowconfig.json` 
in the `workflows` directory) and pass the name of the config file
to Snakemake using the `--configfile` flag:

```bash
snakemake --configfile=config/custom_workflowconfig.json [FLAGS] <target>
```

### Workflow Parameters

Set the `taxonomic_classification` key of the Snakemake configuration dictionary
as shown below:

```json
{
    "taxonomic_classification" : {

        "filter_taxa" : {
            "pct_threshold" : 1
        },

        "kaiju" : {
            "dmp1" : "nodes.dmp",
            "dmp2" : "names.dmp",
            "fmi"  : "kaiju_db_nr.fmi",
            "tar"  : "kaiju_index_nr.tgz",
            "url"  : "http://kaiju.binf.ku.dk/database",
            "out"  : "{sample}.kaiju_output.trim{qual}.out"
        },

        "kaiju_report" : {
            "taxonomic_rank" : "genus",
            "pct_threshold"  : 1
        },

        "sourmash" : { 
            "sbturl"  : "s3-us-west-1.amazonaws.com/spacegraphcats.ucdavis.edu",
            "sbttar"  : "microbe-{database}-sbt-k{kvalue}-2017.05.09.tar.gz",
            "sbtunpack" : "{database}-k{kvalue}.sbt.json",
            "databases" : ["genbank","refseq"],
            "gather_csv_out"        : "{sample}-k{kvalue}.trim{qual}.gather_output.csv",
            "gather_unassigned_out" : "{sample}-k{kvalue}.trim{qual}.gather_unassigned.csv",
            "gather_matches_out"    : "{sample}-k{kvalue}.trim{qual}.gather_matches.csv"
        },

        "visualize_krona" : {
            "input_summary"  : "{sample}.kaiju_output.trim{qual}.summary",
        }
    }
}
```

To use custom values for these parameters, put the configuration dictionary
above (or any subset of it) into a JSON file (e.g.,
`config/custom_workflowparams.json` in the `workflows` directory) and pass the
name of the config file to Snakemake using the `--configfile` flag:

```bash
snakemake --configfile=config/custom_workflowparams.json [FLAGS] <target>
```

