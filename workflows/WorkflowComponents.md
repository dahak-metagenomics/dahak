# Workflow Components

Each directory here represents a different atomic operation in Dahak workflows.

This document describes each operation.

## Dataset Construction

See [`/dataset_construction`](/workflows/dataset_construction/) directory.

Constructs SBTs from external genomic databases and saves them to disk so that they can then be shared and loaded.

## Read Filtering

See [`/read_filtering`](/workflows/read_filtering/) directory.

The read filtering step consists of processing raw reads from a 
sequencer, such as discarding reads with a high uncertainty value
or trimming off adapters.

Tools like Fastqc and Trimmomatic will perform this filtering 
process for the sequencer's reads.

## Assembly

See [`/assembly`](/workflows/assembly/) directory.

The assembly step consists of software to determine the proper
order of the reads, and assemble the genome. The assembly tool
may use short reads (~350 or fewer reads), or it may use 
long reads (>1000 reads). 

Reads are assembled in order into contigs (chunks of contiguous
reads). The contigs are themselves assembled into scaffolds 
that consist of several contigs.

The Spades tool can handle short or long reads, while the Megahit 
tool works better for short reads. Pandaseq can merge overlapping reads.
Metaquast gives assembly statistics that can help evaluate the assembly
(how long, number of fragments, number of contigs, number of scaffolds, 
etc.).

Typically 30-40% of the reads can be fingerprinted by the assembler.

## Comparison

See [`/comparison`](/workflows/comparison/) directory.

Operating at the level of k-mers (representations of the reads),
the comparison step is taking the reads that were not fingerprinted
by the assembler and seeing if they match genomes of other organisms. 

The tool used for comparison is sourmash.

## Functional Inference

See [`/functional_inference`](/workflows/functional_inference/) directory.

Once the assembly step has been completed, the assembly
can be analyzed and annotated using external databases.
Prokka is a tool for functional annotation of contigs.

Variant calling searches for common variants of a given 
gene. Variants are obtained by changing a few genes 
in an existing genome.

ShotMap was originally used for this step, but was 
replaced by Miphaser.


