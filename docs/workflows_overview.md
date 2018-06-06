# Workflows and Workflow Components

When analyzing metagenomic data, different workflows
are broken down into atomic operations. Each directory here
corresponds to an atomic operation (a workflow component).

A flowchart illustrating how each workflow component fits 
together with tools into the overall process is included below:

<img width="500px" src="img/WorkflowFlowchartOriginal.png" />

Each workflow has its own Snakefile. The Snakefile is composed of a 
list of simple rules that specify how an input file is turned into 
an output file. 

The following workflows are required deliverables:

* Taxonomic characterization of bulk metagenome data sets with the sourmash
  tool against public and private reference databases;
* Assembly-based approaches to give higher-confidence gene identity assignment
  than raw read assignment alone;
* MinHash-based taxonomic description of data sets;
* Full-set and marker gene analysis of hybrid assembly/read collections to
  characterize taxonomic content;
* Full-set gene analysis of hybrid assembly/read collections to characterize
  functional content;
* Taxonomic and functional analysis performed on reads left out of the
  assembly;
* Rapid k-mer-based ordination analyses of many samples to provide sample
  groupings and identify potential outliers; and
* Interactive Jupyter notebooks for interpretation of results.

## Workflow Descriptions

For coverage of workflows, see [Workflows.md](Workflows.md).

For coverage of workflow components, see [WorkflowComponents.md](WorkflowComponents.md).

## Running Workflows

To get started running workflows, you will need to install Singularity and
Snakemake. See [GettingStarted.md](/workflows/GettingStarted.md)

The shell commands for each workflow are documented in each subdirectory (for
example, workflows for taxonomic characterization of bulk metagenome data sets
is located in the
[dahak/workflows/taxonomic_classification](/workflows/taxonomic_classification/)
folder).

Snakemake files for workflows are being assembled in the
[dahak-flot](https://github.com/dahak-metagenomics/dahak-flot) repository, with
the intention of porting them back to the dahak repository.

