
# Dahak

Dahak is a software suite that integrates state-of-the-art open source tools for metagenomic analyses. Tools in the dahak software suite will perform various steps in metagenomic analysis workflows including data pre-processing, metagenome assembly, taxonomic and functional classification, genome binning, and gene assignment. We aim to deliver the analytical framework as a robust and reliable containerized workflow system, which will be free from dependency, installation, and execution problems typically associated with other open-source bioinformatics solutions. This will maximize the transparency, data provenance (i.e., the process of tracing the origins of data and its movement through the workflow), and reproducibility.

## Getting Started

Analysis protocols can be found in the [workflows](https://github.com/dahak-metagenomics/dahak/tree/master/workflows) directory. It is assumed that analysis will begin with [read filtering](https://github.com/dahak-metagenomics/dahak/tree/master/workflows/read_filtering) and instructions for Docker installation are included there. 

## Prerequisites

Currently, for the sake of simplicity, it is assumed that all workflow steps
will be run from Ubuntu 16.04 LTS.

dahak is not a standalone program, but rather a collection of workflows
that are defined in snakemake files and that utilize bioconda and Docker
to install and run software for different tasks.

See the [`workflows/`](/workflows/) directory to get started.

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

Please read [CONTRIBUTING.md](https://github.com/dahak-metagenomics/dahak/blob/master/CONTRIBUTING.md) for details on our code of conduct and the process for submitting pull requests to us.

## Contributors

Phillip Brooks<sup>1</sup>, Charles Reid<sup>1</sup>, Bruce Budowle<sup>2</sup>, Chris Grahlmann<sup>3</sup>, Stephanie L. Guertin<sup>3</sup>, F. Curtis Hewitt<sup>3</sup>, Alexander F. Koeppel<sup>4</sup>, Oana I. Lungu<sup>3</sup>, Krista L. Ternus<sup>3</sup>, Stephen D. Turner<sup>4,</sup><sup>5</sup>, C. Titus Brown<sup>1</sup>

<sup>1</sup>School of Veterinary Medicine, University of California Davis, Davis, CA, United States of America 

<sup>2</sup>Institute of Applied Genetics, Department of Molecular and Medical Genetics, University of North Texas Health Science Center, Fort Worth, Texas, United States of America

<sup>3</sup>Signature Science, LLC, Austin, Texas, United States of America

<sup>4</sup>Department of Public Health Sciences, University of Virginia, Charlottesville, VA, United States of America

<sup>5</sup>Bioinformatics Core, University of Virginia School of Medicine, Charlottesville, VA, United States of America

See also the list of [contributors](https://github.com/dahak-metagenomics/dahak/graphs/contributors) who participated in this project.

## License

This project is licensed under the BSD 3-Clause License - see the [LICENSE](https://github.com/dahak-metagenomics/dahak/blob/master/LICENSE) file for details.

## Acknowledgments

* [Bioconda](https://bioconda.github.io) 
* Hat tip to anyone whose code was used

