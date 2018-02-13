# Workflows and Workflow Components

When analyzing metagenomic data, different workflows
(taxonomic classification, contig annotation, or SBT assembly) 
are broken down into atomic operations. Each directory here
corresponds to an atomic operation (a workflow component).

A flowchart illustrating how each workflow component fits 
together with tools into the overall process is included below:

<img width="500px" src="/resources/WorkflowFlowchartOriginal.png" />

Currently, each workflow component has its own snakefile.
Eventually, dahak workflows will consist of a single master
snakefile calling sub-makefiles. 

The following workflows are required deliverables:
* Taxonomic characterization of bulk metagenome data sets with the sourmash tool against public and private reference databases;
* Assembly-based approaches to give higher-confidence gene identity assignment than raw read assignment alone;
* MinHash-based taxonomic description of data sets;
* Full-set and marker gene analysis of hybrid assembly/read collections to characterize taxonomic content;
* Full-set gene analysis of hybrid assembly/read collections to characterize functional content;
* Taxonomic and functional analysis performed on reads left out of the assembly;
* Rapid k-mer-based ordination analyses of many samples to provide sample groupings and identify potential outliers; and
* Interactive Jupyter notebooks for interpretation of results.


## Workflows

For coverage of workflows, see [Workflows.md](/workflows/Workflows.md).

## Workflow Components

For coverage of workflow components, see [WorkflowComponents.md](/workflows/WorkflowComponents.md).


