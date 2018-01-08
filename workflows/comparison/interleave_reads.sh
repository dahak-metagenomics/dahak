#!/bin/bash

#### Interleave reads as an alternative to --merge

for i in *_1.trim2.fq.gz
do
        #Remove _1.trim2.fq from file name to create base
        base=$(basename ${i} _1.trim2.fq.gz)
        echo ${base}

        docker run -v ${PWD}:/data quay.io/biocontainers/khmer:2.1.2--py35_0 \
        interleave-reads.py \
        /data/${base}_1.trim2.fq.gz /data/${base}_2.trim2.fq.gz \
        -o /data/${base}.pe.trim2.fq \
        --gzip
done

for i in *_1.trim30.fq.gz
do
        #Remove _1.trim30.fq from file name to create base
        base=$(basename ${i} _1.trim30.fq.gz)
        echo ${base}

        docker run -v ${PWD}:/data quay.io/biocontainers/khmer:2.1.2--py35_0 \
        interleave-reads.py \
        /data/${base}_1.trim30.fq.gz /data/${base}_2.trim30.fq.gz \
        -o /data/${base}.pe.trim30.fq \
        --gzip
done
