# Quick Start

A flowchart illustrating how each workflow component fits 
together with tools into the overall process is included below:

![workflow flowchart](img/WorkflowFlowchartOriginal.png)


## Quick Start: Read Filtering

To run the read filtering workflow, call snakemake and pass the
`read_filtering_workflow` build rule:

```
$ SINGULARITY_BINDPATH="data:/data" \
    snakemake \
    --use-singularity \
    read_filtering_workflow
``` 

When this command is run, it assembles the filenames of all files 
that are created by the post-trimming step of the read filtering
workflow.



More information about the read filtering workflow:

* [Read Filtering Walkthrough](readfilt_walkthru.md)
* [Read Filtering Snakemake Rules](readfilt_snakemake.md)
* [Read Filtering Parameters and Configuration](readfilt_config.md)


