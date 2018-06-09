# Dahak

Dahak is a software suite that integrates state-of-the-art open source tools
for metagenomic analyses. Tools in the dahak software suite will perform
various steps in metagenomic analysis workflows including data pre-processing,
metagenome assembly, taxonomic and functional classification, genome binning,
and gene assignment. We aim to deliver the analytical framework as a robust and
reliable containerized workflow system, which will be free from dependency,
installation, and execution problems typically associated with other
open-source bioinformatics solutions. This will maximize the transparency, data
provenance (i.e., the process of tracing the origins of data and its movement
through the workflow), and reproducibility.


## Benchmarking Data 

For purposes of benchmarking this project will use the following datasets: 

| Dataset |Description |
|---|---|
| Shakya complete | Complete metagenomic dataset from Shakya et al., 2013<sup>*</sup> containing bacterial and archaeal genomes|
| Shakya subset 50 | 50 percent of the reads from Shakya complete|
| Shakya subset 25 | 25 percent of the reads from Shakya complete|
| Shakya subset 10 | 10 percent of the reads from Shakya complete|

<sup>*</sup>[Shakya, M., C. Quince, J. H. Campbell, Z. K. Yang, C. W. Schadt and M. Podar (2013). "Comparative metagenomic and rRNA microbial diversity characterization using archaeal and bacterial synthetic communities." Environ Microbiol 15(6): 1882-1899.](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC3665634/)


## Requirements and Installation

Dahak is not a standalone program, but rather a collection of workflows
that are defined in Snakemake files. These workflows utilize Bioconda,
Biocontainers, and Docker/Singularity containerization technologies to
install and run software for different tasks.

The following software is required to run Dahak workflows:

**REQUIRED:**

* Python 3
* Snakemake
* Conda
* Singularity or Docker

**TARGET PLATFORM:**

* Singularity >= 2.4 and Sun Grid Compute Engine (utilizes available Singularity, does not require sudo access)
* (Optional) Ubuntu 16.04 (Xenial) and Docker (requires sudo access)

See [Installing](installing.md) for detailed instructions
on installing each of the required components listed above,
including Singularity and Docker.


## Quick Start

To run Dahak workflows, use Snakemake from the command line.  Each workflow component is
comprised of a set of Snakemake rules. 

[Snakemake](https://snakemake.readthedocs.io/) is a Python program that assembles and
runs tasks using a task graph approach. See [Installing](installing.md). 

Dahak workflows benefit directly from Snakemake's rich feature set and capabilities.
There is an extensive documentation page on [executing Snakemake](https://snakemake.readthedocs.io/en/stable/executable.html),
and its command line options. There are other projects demonstrating ways of creating 
[snakemake-profiles](https://github.com/snakemake-profiles/doc), or platform-specific
configuration profiles.

Generally, Snakemake is called by passing command line flags and the name of a
target file or rule name:

```
$ snakemake [FLAGS] <target>
```

By default, Snakemake looks for rules and targets that are defined in the file
`Snakefile`.

The Dahak Snakefile contains `singularity:` directives, which specify a
Singularity image to pull and use to run the given commands. These are not
used by default; to force Snakemake to use Singularity to run commands with
`singularity:` directives , use the `--use-singularity` flag:

```
snakemake --use-singularity ...
```

To specify a directory for Singularity to bind-mount, use the
`SINGULARITY_BINDPATH` environment variable. These are both required:

```
$ SINGULARITY_BINDPATH="data:/data" snakemake --use-singularity <target>
```

These workflows will use default parameter values for each step of the
workflow.

To use a custom configuration file (JSON or YAML format), use the
`--configfile` flag:

```
$ snakemake --configfile myworkflowparams_2018-01-31.json ...
```

All together, this will look like:

```
$ SINGULARITY_BINDPATH="data:/data" snakemake \
    --configfile myworkflowparams_2018-01-31.json \
    --use-singularity <target>
``` 


## Workflows 

Dahak provides a set of workflow components that all fit together to perform 
various useful tasks.

See the [Workflows](workflows.md) page for an overview of the metagenomic workflows
provided by dahak and how these workflows fit together.

See the [Running Workflows](workflows_running.md) page for instructions on 
running workflows.

In addition to the Snakemake rules for each workflow, which are written to
run software via Singularity in an HPC environment (Sun Grid Engine),
we also provide walkthroughs of running commands interactively using
Docker, which requires sudo access but can be performed with cloud compute
nodes.

* [Read Filtering](workflow_readfilt.md)
* [Taxonomic Classification](workflow_taxclass.md)
* Assembly
* Metagenomic Comparison
* Variant Calling
* Functional Inference


## Parameters and Configuration

See the [Parameters and Configuration](config.md) page for details about
controlling how each workflow operates, and how to use parameter presets.


# Contributing

Please read
[CONTRIBUTING.md](https://github.com/dahak-metagenomics/dahak/blob/master/CONTRIBUTING.md)
for details on our code of conduct and the process for submitting pull requests to us.

# Contributors

Phillip Brooks<sup>1</sup>, Charles Reid<sup>1</sup>, Bruce Budowle<sup>2</sup>, Chris Grahlmann<sup>3</sup>, Stephanie L. Guertin<sup>3</sup>, F. Curtis Hewitt<sup>3</sup>, Alexander F. Koeppel<sup>4</sup>, Oana I. Lungu<sup>3</sup>, Krista L. Ternus<sup>3</sup>, Stephen D. Turner<sup>4,</sup><sup>5</sup>, C. Titus Brown<sup>1</sup>

<sup>1</sup>School of Veterinary Medicine, University of California Davis, Davis, CA, United States of America 

<sup>2</sup>Institute of Applied Genetics, Department of Molecular and Medical Genetics, University of North Texas Health Science Center, Fort Worth, Texas, United States of America

<sup>3</sup>Signature Science, LLC, Austin, Texas, United States of America

<sup>4</sup>Department of Public Health Sciences, University of Virginia, Charlottesville, VA, United States of America

<sup>5</sup>Bioinformatics Core, University of Virginia School of Medicine, Charlottesville, VA, United States of America

See also the list of [contributors](https://github.com/dahak-metagenomics/dahak/graphs/contributors) who participated in this project.


## License

This project is licensed under the BSD 3-Clause License - see the
[LICENSE](https://github.com/dahak-metagenomics/dahak/blob/master/LICENSE) file
for details.


------------

# Existing README

## Getting Started

Analysis protocols can be found in the
[workflows](https://github.com/dahak-metagenomics/dahak/tree/master/workflows)
directory. It is assumed that analysis will begin with 
[read filtering](https://github.com/dahak-metagenomics/dahak/tree/master/workflows/read_filtering).

You can run these protocols interactively using Docker or automate them using
Snakemake and Singularity. See [workflows](workflows.md)
for Docker, Snakemake, and Singularity install instructions. 

The assembly, comparison, functional inference, and taxonomic classification
workflows are dependent upon the output of the read filtering workflow data.
You can download our data to use in the read filtering protocol from the Open
Science Framework. See the section below titled "Data" and the read filtering
protocol for more information. 

## Prerequisites

Currently, for the sake of simplicity, it is assumed that all workflow steps
will be run on systems with the following characteristics:

* Ubuntu 16.04 Xenial LTS
* Singularity installed
* Conda installed
* Snakemake installed

Dahak is not a standalone program, but rather a collection of workflows
that are defined in Snakemake files and that utilize Bioconda and 
Docker/Singularity to install and run software for different tasks.

## Data 

For purposes of benchmarking this project will use the following datasets: 

| Dataset |Description |
|---|---|
| Shakya complete | Complete metagenomic dataset from Shakya et al., 2013<sup>*</sup> containing bacterial and archaeal genomes|
| Shakya subset 50 | 50 percent of the reads from Shakya complete|
| Shakya subset 25 | 25 percent of the reads from Shakya complete|
| Shakya subset 10 | 10 percent of the reads from Shakya complete|

<sup>*</sup>[Shakya, M., C. Quince, J. H. Campbell, Z. K. Yang, C. W. Schadt and M. Podar (2013). "Comparative metagenomic and rRNA microbial diversity characterization using archaeal and bacterial synthetic communities." Environ Microbiol 15(6): 1882-1899.](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC3665634/)
 

## Contributing

Please read
[CONTRIBUTING.md](https://github.com/dahak-metagenomics/dahak/blob/master/CONTRIBUTING.md)
for details on our code of conduct and the process for submitting pull requests to us.

## Contributors

Phillip Brooks<sup>1</sup>, Charles Reid<sup>1</sup>, Bruce Budowle<sup>2</sup>, Chris Grahlmann<sup>3</sup>, Stephanie L. Guertin<sup>3</sup>, F. Curtis Hewitt<sup>3</sup>, Alexander F. Koeppel<sup>4</sup>, Oana I. Lungu<sup>3</sup>, Krista L. Ternus<sup>3</sup>, Stephen D. Turner<sup>4,</sup><sup>5</sup>, C. Titus Brown<sup>1</sup>

<sup>1</sup>School of Veterinary Medicine, University of California Davis, Davis, CA, United States of America 

<sup>2</sup>Institute of Applied Genetics, Department of Molecular and Medical Genetics, University of North Texas Health Science Center, Fort Worth, Texas, United States of America

<sup>3</sup>Signature Science, LLC, Austin, Texas, United States of America

<sup>4</sup>Department of Public Health Sciences, University of Virginia, Charlottesville, VA, United States of America

<sup>5</sup>Bioinformatics Core, University of Virginia School of Medicine, Charlottesville, VA, United States of America

See also the list of [contributors](https://github.com/dahak-metagenomics/dahak/graphs/contributors) who participated in this project.

## License

This project is licensed under the BSD 3-Clause License - see the
[LICENSE](https://github.com/dahak-metagenomics/dahak/blob/master/LICENSE) file
for details.

## Acknowledgments

* [Bioconda](https://bioconda.github.io) 
* Hat tip to anyone whose code was used

