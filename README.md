
# dahak

dahak is a software suite that integrates state-of-the-art open source tools for metagenomic analyses. Tools in the dahak software suite will perform various steps in metagenomic analysis workflows including data pre-processing, metagenome assembly, taxonomic and functional classification, genome binning, and gene assignment. We aim to deliver the analytical framework as a robust and reliable containerized workflow system, which will be free from dependency, installation, and execution problems typically associated with other open-source bioinformatics solutions. This will maximize the transparency, data provenance (i.e., the process of tracing the origins of data and its movement through the workflow), and reproducibility.

## Getting Started

Analysis protocols can be found in the [workflows](https://github.com/dahak-metagenomics/dahak/tree/master/workflows) directory. It is assumed that analysis will begin with [read filtering](https://github.com/dahak-metagenomics/dahak/tree/master/workflows/read_filtering) and instructions for Docker installation are included there. 

## Prerequisites

It is assumed that all steps will be executed using an Ubuntu 16.04 image. 

## Data 
For purposes of benchmarking this project will use the following datasets: 

- [Shakya, M., C. Quince, J. H. Campbell, Z. K. Yang, C. W. Schadt and M. Podar (2013). "Comparative metagenomic and rRNA microbial diversity characterization using archaeal and bacterial synthetic communities." Environ Microbiol 15(6): 1882-1899.] (https://www.ncbi.nlm.nih.gov/pmc/articles/PMC3665634/)
  - NCBI SRA Accession: [SRX200676](https://www.ncbi.nlm.nih.gov/sra/?term=SRX200676)

- 50% subsample of Shakya et al. 2013*
  SRR606249_subset50_1.fq.gz
  SRR606249_subset50_1.fq.gz

- 25% subsample of Shakya et al. 2013*
  SRR606249_subset25_1.fq.gz
  SRR606249_subset25_1.fq.gz
  
- 10% subsample of Shakya et al. 2013*
  SRR606249_subset10_1.fq.gz
  SRR606249_subset10_1.fq.gz

*Subsampled data sets can be retrieved from the Open Science Framework using the [osfclient](https://github.com/dib-lab/osf-cli). See example in [read_filtering](https://github.com/dahak-metagenomics/dahak/tree/master/workflows/read_filtering). 

## Contributing

Please read [CONTRIBUTING.md](https://gist.github.com/PurpleBooth/b24679402957c63ec426) for details on our code of conduct, and the process for submitting pull requests to us.

## Contributors

Phillip Brooks<sup>1</sup>, Bruce Budowle<sup>2</sup>, Chris Grahlmann<sup>3</sup>, Stephanie L. Guertin<sup>3</sup>, F. Curtis Hewitt<sup>3</sup>, Dana R. Kadavy<sup>3</sup>, Alexander F. Koeppel<sup>4</sup>, Oana I. Lungu<sup>3</sup>, Krista L. Ternus<sup>3</sup>, Stephen D. Turner<sup>4</sup>, C. Titus Brown<sup>1</sup>

1 = School of Veterinary Medicine, University of California Davis, Davis, CA, United States of America 
2 = Institute of Applied Genetics, Department of Molecular and Medical Genetics, University of North Texas Health Science Center, Fort Worth, Texas, United States of America
3 = Signature Science, LLC, Austin, Texas, United States of America
4 = Department of Public Health Sciences, University of Virginia, Charlottesville, VA, United States of America

See also the list of [contributors](https://github.com/dahak-metagenomics/dahak/graphs/contributors) who participated in this project.

## License

This project is licensed under the BSD 3-Clause License - see the [LICENSE.md](LICENSE.md) file for details

## Acknowledgments

* [Bioconda](https://bioconda.github.io) 
* Hat tip to anyone who's code was used

