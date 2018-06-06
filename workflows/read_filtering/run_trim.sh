#!/bin/bash

SINGULARITY_BINDPATH="data:/data" snakemake --use-singularity trim
