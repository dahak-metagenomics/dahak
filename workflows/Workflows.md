# Workflow 

Dahak is designed to chain together tools for various workflows. 
Each workflow component is defined in its own directory. 
This document describes the components that compose each workflow.

In the following diagrams, the colors denote meaning:
* blue - metagenome assembly, alignment, variant calling
* red - contig annotation and gene assignment
* purple -taxonomic and functional analysis of reads
* green - sample comparison

Terminal software/outputs are denoted by ovals.

## Quality Assessment of Datasets

<img width="500px" src="/resources/Workflow1_QA.png" />

## Taxonomic Classification Using Custom Database

<img width="500px" src="/resources/Workflow2_TaxClass.png" />

## Abundance Estimation and Variance Calling

<img width="500px" src="/resources/Workflow3_VC.png" />

## Sub-Element Identification

<img width="500px" src="/resources/Workflow4_SubID.png" />

## Functional Inference

<img width="500px" src="/resources/Workflow5_Function.png" />

## Sample Comparison

<img width="500px" src="/resources/Workflow6_Comparison.png" />

