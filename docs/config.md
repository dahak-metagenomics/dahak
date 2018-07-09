# Workflow Configuration

The `workflows/config/` directory contains files used to set 
key-value pairs in the configuration dictionary used by Snakemake.

## Data Files, Workflow Config, and Parameters

The `dahak/workflows/config/` directory contains configuration files for
Dahak workflows. There are three types of configuration details that the user
may wish to customize:

* **Data files** (a list of names and URLs for read files; these read files do not
  all necessarily need to be used in the workflow)
    * See `dahak/workflows/config/example_datafiles.json` for an example

* **Workflow configuration** (specifying which read files to run each workflow on)
    * See `dahak/workflows/config/example_workflowconfig.json` for an example

* **Workflow parameters** (parameters specifying how the workflow will run)
    * See `dahak/workflows/config/example_workflowparams.json` for an example


## .settings vs .json files

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

```
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

If the user wishes to bump the version of trimmomatic to (e.g.) 0.38,
but not change the version of khmer or sourmash, the user can specify
a JSON file with the following configuration block:

```
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

```
$ snakemake --config=config/custom_workflowparams.json \
        [FLAGS] <target>
```

This will only override the container version used for trimmomatic, and will
use the defaults for all other container images.


