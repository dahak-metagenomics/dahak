'''
Author: Phillip Brooks
Affiliation: UC Davis Lab for Data Intensive Biology
Aim: A Snakemake workflow to calculate unique k-mers, calculate signatures for, and classify
McIntyre datasets
Date: Wed May 2 2018
Run: snakemake --use-conda --use-singularity
Latest modification:
'''
##--------------------------------------------------------------------------------------##
## Variables declaration
## Declaring some variables
## (SAMPLES, )
##--------------------------------------------------------------------------------------##

SAMPLES = ['Huttenhower_HC1.fasta.gz','Huttenhower_HC2.fasta.gz', 'Huttenhower_LC1.fasta.gz', 'Huttenhower_LC2.fasta.gz',
'Huttenhower_LC3.fasta.gz', 'Huttenhower_LC4.fasta.gz', 'Huttenhower_LC5.fasta.gz', 'Huttenhower_LC6.fasta.gz',
'Huttenhower_LC7.fasta.gz', 'Huttenhower_LC8.fasta.gz', 'UnAmbiguouslyMapped_ds.7.fq.gz', 'UnAmbiguouslyMapped_ds.buccal.fq.gz',
'UnAmbiguouslyMapped_ds.cityparks.fq.gz','UnAmbiguouslyMapped_ds.gut.fq.gz', 'UnAmbiguouslyMapped_ds.hous1.fq.gz',
'UnAmbiguouslyMapped_ds.hous2.fq.gz', 'UnAmbiguouslyMapped_ds.nycsm.fq.gz', 'UnAmbiguouslyMapped_ds.soil.fq.gz']

rule all:
    input:
        expand('outputs/classification/sourmash/{sample}.scaled10k.k51.gather.matches.csv',
               sample=SAMPLES,
               ),
        expand('outputs/stats/unique_kmers.txt',
               sample=SAMPLES,
               )

rule calcuate_unique_51mers:
    input:
	'inputs/data/{sample}'
    output:
        'outputs/stats/unique_kmers.txt'
    singularity:
        'docker://quay.io/biocontainers/khmer:2.1.2--py35_0'
    shell:
        '''
        mkdir -p outputs/stats/
        touch outputs/stats/unique_kmers.txt
        unique-kmers.py -k 51 {input} | tee {output}'
        '''
# To use os.path.join,
# which is more robust than manually writing the separator.
import os

# Association between output files and source links
links = {
        'refseq-k51.sbt.json' : 'https://s3-us-west-1.amazonaws.com/spacegraphcats.ucdavis.edu/microbe-refseq-sbt-k51-2017.05.09.tar.gz',
        'genbank-k51.sbt.json' : 'https://s3-us-west-1.amazonaws.com/spacegraphcats.ucdavis.edu/microbe-genbank-sbt-k51-2017.05.09.tar.gz'}

# Make this association accessible via a function of wildcards
def chainfile2link(wildcards):
    return links[wildcards.chainfile]

rule download:
    input:
    output:
        # We inform snakemake what this rule will generate
        os.path.join('inputs/databases/', '{chainfile}')
    message:
        '--- Downloading Data.'
    params:
        # using a function of wildcards in params
        link = chainfile2link,
    shell:
        '''
        mkdir -p inputs/databases/
        wget {params.link}
        tar xf microbe-refseq-sbt-k51-2017.05.09.tar.gz -C inputs/databases
        tar xf microbe-genbank-sbt-k51-2017.05.09.tar.gz -C inputs/databases
       '''

rule calculate_signatures:
    input:
        'inputs/data/{sample}',
    output:
        'output/classification/signatures/{sample}.sig',
    message:
        '--- Compute sourmash signatures with quality trimmed data with sourmash'
    singularity:
        'docker://quay.io/biocontainers/sourmash:2.0.0a2--py36_0'
    log:
        'outputs/classification/sourmash/{sample}_compute.log'
    benchmark:
        'benchmarks/{sample}.compute.benchmark.txt'
    shell:
       'sourmash compute --scaled 10000 -k 51 {input} -o {output}'

rule classify_signatures:
    input:
        sig= 'output/classification/signatures/{sample}.sig',
        ref= 'inputs/databases/refseq-k51.sbt.json',
        gen= 'inputs/databases/genbank-k51.sbt.json'
    output:
        'outputs/classification/sourmash/{sample}.scaled10k.k51.gather.matches.csv'
    message:
        '--- Classify sourmash signatures with quality trimmed data with sourmash'
    singularity:
        'docker://quay.io/biocontainers/sourmash:2.0.0a2--py36_0'
    log:
        'outputs/classification/sourmash/{sample}_gather.log'
    benchmark:
        'benchmarks/{sample}.gather.benchmark.txt'
    shell:
        'sourmash gather -k 51 {input.sig} {input.ref} {input.gen} -o {output}'
