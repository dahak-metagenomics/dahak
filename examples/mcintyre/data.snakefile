'''
Author: Phillip Brooks
Affiliation: UC Davis Lab for Data Intensive Biology
Aim: A Snakemake workflow to download McIntyre datasets
Date: Wed May 2 2018
Run: snakemake --use-conda --use-singularity
Latest modification:
'''

# Use os.path.join,
# which is more robust than manually writing the separator.
import os

# Association between output files and source links
links = {
    'Huttenhower_HC1.fasta.gz':'ftp://ftp-private.ncbi.nlm.nih.gov/nist-immsa/IMMSA/Huttenhower_HC1.fasta.gz',
    'Huttenhower_HC2.fasta.gz':'ftp://ftp-private.ncbi.nlm.nih.gov/nist-immsa/IMMSA/Huttenhower_HC2.fasta.gz',
    'Huttenhower_LC1.fasta.gz':'ftp://ftp-private.ncbi.nlm.nih.gov/nist-immsa/IMMSA/Huttenhower_LC1.fasta.gz',
    'Huttenhower_LC2.fasta.gz':'ftp://ftp-private.ncbi.nlm.nih.gov/nist-immsa/IMMSA/Huttenhower_LC2.fasta.gz',
    'Huttenhower_LC3.fasta.gz':'ftp://ftp-private.ncbi.nlm.nih.gov/nist-immsa/IMMSA/Huttenhower_LC3.fasta.gz',
    'Huttenhower_LC4.fasta.gz':'ftp://ftp-private.ncbi.nlm.nih.gov/nist-immsa/IMMSA/Huttenhower_LC4.fasta.gz',
    'Huttenhower_LC5.fasta.gz':'ftp://ftp-private.ncbi.nlm.nih.gov/nist-immsa/IMMSA/Huttenhower_LC5.fasta.gz',
    'Huttenhower_LC6.fasta.gz':'ftp://ftp-private.ncbi.nlm.nih.gov/nist-immsa/IMMSA/Huttenhower_LC6.fasta.gz',
    'Huttenhower_LC7.fasta.gz':'ftp://ftp-private.ncbi.nlm.nih.gov/nist-immsa/IMMSA/Huttenhower_LC7.fasta.gz',
    'Huttenhower_LC8.fasta.gz':'ftp://ftp-private.ncbi.nlm.nih.gov/nist-immsa/IMMSA/Huttenhower_LC8.fasta.gz',
    'UnAmbiguouslyMapped_ds.7.fq.gz':'ftp://ftp-private.ncbi.nlm.nih.gov/nist-immsa/IMMSA/UnAmbiguouslyMapped_ds.7.fq.gz',
    'UnAmbiguouslyMapped_ds.buccal.fq.gz':'ftp://ftp-private.ncbi.nlm.nih.gov/nist-immsa/IMMSA/UnAmbiguouslyMapped_ds.buccal.fq.gz',
    'UnAmbiguouslyMapped_ds.cityparks.fq.gz':'ftp://ftp-private.ncbi.nlm.nih.gov/nist-immsa/IMMSA/UnAmbiguouslyMapped_ds.cityparks.fq.gz',
    'UnAmbiguouslyMapped_ds.gut.fq.gz':'ftp://ftp-private.ncbi.nlm.nih.gov/nist-immsa/IMMSA/UnAmbiguouslyMapped_ds.gut.fq.gz',
    'UnAmbiguouslyMapped_ds.hous1.fq.gz':'ftp://ftp-private.ncbi.nlm.nih.gov/nist-immsa/IMMSA/UnAmbiguouslyMapped_ds.hous1.fq.gz',
    'UnAmbiguouslyMapped_ds.hous2.fq.gz':'ftp://ftp-private.ncbi.nlm.nih.gov/nist-immsa/IMMSA/UnAmbiguouslyMapped_ds.hous2.fq.gz',
    'UnAmbiguouslyMapped_ds.nycsm.fq.gz':'ftp://ftp-private.ncbi.nlm.nih.gov/nist-immsa/IMMSA/UnAmbiguouslyMapped_ds.nycsm.fq.gz',
    'UnAmbiguouslyMapped_ds.soil.fq.gz':'ftp://ftp-private.ncbi.nlm.nih.gov/nist-immsa/IMMSA/UnAmbiguouslyMapped_ds.soil.fq.gz'}


# Make this association accessible via a function of wildcards
def chainfile2link(wildcards):
    return links[wildcards.chainfile]


# First rule will drive the rest of the workflow
rule all:
    input:
        # expand generates the list of the final files we want
        expand(os.path.join("inputs/data/", "{chainfile}"), chainfile=links.keys())


rule download:
    output:
        # We inform snakemake what this rule will generate
        os.path.join("inputs/data/", "{chainfile}")
    params:
        # using a function of wildcards in params
        link = chainfile2link,
    shell:
        """
        mkdir -p inputs/data
        wget {params.link} -O {output}
        """
