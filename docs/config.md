# Snakemake Configuration

The `workflows/config/` directory contains files used to set 
key-value pairs in the configuration dictionary used by Snakemake.

To use a custom configuration file (JSON or YAML format), use the
`--configfile` flag:

```bash
snakemake --configfile my_workflow_params.json ...
```


## Data Files, Workflow Config, and Parameters

The `dahak/workflows/config/` directory contains configuration files for
Dahak workflows. There are three types of configuration details that the user
may wish to customize:

* **Data files** (a list of names and URLs for read files; these read files do not
  all necessarily need to be used in the workflow)
    * See [`dahak/workflows/config/example_datafiles.json`](https://github.com/dahak-metagenomics/dahak/blob/master/workflows/config/example_datafiles.json)
      for an example

* **Workflow configuration** (specifying which read files to run each workflow on)
    * See [`dahak/workflows/config/example_workflowconfig.json`](https://github.com/dahak-metagenomics/dahak/blob/master/workflows/config/example_workflowconfig.json)
      for an example

* **Workflow parameters** (parameters specifying how the workflow will run)
    * See [`dahak/workflows/config/example_workflowparams.json`](https://github.com/dahak-metagenomics/dahak/blob/master/workflows/config/example_workflowparams.json)
      for an example


## How do I specify my data files?

To set the names and URLs of read files, set the `files` key in the Snakemake
configuration dictionary to a list of key-value pairs, where the key is the 
name of the read file and the value is the URL of the file (do not include 
`http://` or `https://` in the URL).

For example, the following JSON block will provide a list of reads and their
corresponding URLs:

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

This can be placed in a JSON file like `dahak/workflows/config/custom_datafiles.json` 
and passed to Snakemake using the `--config` flag like:

```bash
snakemake --config=config/custom_datafiles.json \
        [FLAGS] <target>
```

**NOTE:** Dahak assumes that read files are not present on the local machine and
uses a rule to download the reads from the given URL if they are not present.
If your read files *are* present locally, they must be put into the temporary
directory (set by `data_dir` key in the Snakemake configuration dictionary, 
`data/` by default) so that Snakemake will find them. If Snakemake finds the 
read files, the download command will not be run. You can use an empty string
for the URLs in this case.


## How do I specify my workflow configuration?

The workflow configuration file specifies details about
*which* workflow should be run. This is typically just
the name of the samples to run the workflow on, and a 
quality value or a k value.

Set the `workflows` key of the Snakemake configuration dictionary to a
dictionary containing details about the workflow you want to run.  The workflow
configuration values are values that will end up in the final output file's
filename.

```json
{
    "workflows" : {
        "name_of_workflow" : {
            "workflow_option" : "workflow_option_value"
        }
    }
}
```

For example, here is what the workflow configuration looks like
for the assembly workflow:

```json
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

Each workflow component has a "Snakemake" page that covers
workflow configuration options and details for the respective workflow.  Use the
navigation menu on the left and select the workflow component of interest, then
pick the "Snakemake" page.

## How do I specify my workflow parameters?

Workflow parameters specify parameters that are used when executing
individual workflow steps. These parameters are not incorporated in
the final filename and are usually more extensive.

These are set using a key that is the name of the workflow component.
For example, the assembly workflow parameters section of the workflow
parameters file looks like this:


```json
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

Each workflow component has a "Snakemake" page that covers workflow parameters
and details for the respective workflow.  Use the navigation menu on the left
and select the workflow component of interest, then pick the "Snakemake" page.


## .settings (Defaults) vs .json (Overriding Defaults)

The `*.settings` files are Python scripts that set the default
Snakemake configuration dictionary. Each `*.settings` file is
prefixed by `default_` because it is setting default values.

If the user does not specify a particular configuration dictionary
key-value pair, then the default key-value pair will be used.
However, if the user sets a key-value pair, it will override
the default value.

This allows the user to customize any configuration key-value pair
used by a workflow without having to explicitly specify every 
configuration key-value pair.

For example, by default the version of each container image for each
program obtained from the biocontainers project is specified in the
top-level `biocontainers` key in `default_parameters.settings`:

```python
config_default = {

    ...

    "biocontainers" : {
        "sourmash" : {
            "use_local" : False,
            "quayurl" : "quay.io/biocontainers/sourmash",
            "version" : "2.0.0a3--py36_0"
        },
        "trimmomatic" : {
            "use_local" : False,
            "quayurl" : "quay.io/biocontainers/trimmomatic",
            "version" : "0.36--5"
        },
        "khmer" : {
            "use_local" : False,
            "quayurl" : "quay.io/biocontainers/khmer",
            "version" : "2.1.2--py35_0"
        },

        ...
```

(Note the `*.settings` files and the above code are Python, not JSON.)

If the user wishes to bump the version of trimmomatic to (e.g.) 0.38,
but not change the version of khmer or sourmash, the user can specify
a JSON file with the following configuration block:

```json
{
    "biocontainers" : {
        "trimmomatic" : {
            "use_local" : false,
            "quayurl" : "quay.io/biocontainers/trimmomatic",
            "version" : "0.38--5"
        }
    }
}
```

This can be placed in a JSON file like `dahak/workflows/config/custom_workflowparams.json` 
and passed to Snakemake using the `--config` flag like:

```bash
snakemake --config=config/custom_workflowparams.json \
        [FLAGS] <target>
```

This will only override the container version used for trimmomatic, and will
use the defaults for all other container images.


