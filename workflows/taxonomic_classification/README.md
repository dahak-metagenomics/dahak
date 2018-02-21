## Taxonomic classification using [sourmash](http://sourmash.readthedocs.io/en/latest/) and [kaiju](http://kaiju.binf.ku.dk) 

Requirements (assumes you have already run `read_filtering` step with Ubuntu 16.04 LTS):

- At least 120 GB disk space 
- At least 32 GB RAM 
- Updated packages (see read filtering)
- Docker (see [`read_filtering` workflow instructions](/workflows/read_filtering/README.md) for details)
- (Optional) OSF CLI (command-line interface; see [`read_filtering` workflow instructions](/workflows/read_filtering/README.md)) 

Sourmash is a tool for calculating and comparing MinHash signatures. Sourmash gather allows us to taxonomically classify the components of a metagenome by comparing hashes in our dataset to hashes in a sequence bloom tree (SBT) representing genomes. 

First, let's download two SBTs containing hashes that represent the microbial genomes in the [NCBI GenBank](#) and [RefSeq](#) databases. 

(Note: these are each several GB in size, and unzipped they take up around 100 GB of space.)

```
mkdir data/
cd data/
curl -O https://s3-us-west-1.amazonaws.com/spacegraphcats.ucdavis.edu/microbe-refseq-sbt-k51-2017.05.09.tar.gz
curl -O https://s3-us-west-1.amazonaws.com/spacegraphcats.ucdavis.edu/microbe-refseq-sbt-k31-2017.05.09.tar.gz
curl -O https://s3-us-west-1.amazonaws.com/spacegraphcats.ucdavis.edu/microbe-refseq-sbt-k21-2017.05.09.tar.gz
curl -O https://s3-us-west-1.amazonaws.com/spacegraphcats.ucdavis.edu/microbe-genbank-sbt-k51-2017.05.09.tar.gz
curl -O https://s3-us-west-1.amazonaws.com/spacegraphcats.ucdavis.edu/microbe-genbank-sbt-k31-2017.05.09.tar.gz
curl -O https://s3-us-west-1.amazonaws.com/spacegraphcats.ucdavis.edu/microbe-genbank-sbt-k21-2017.05.09.tar.gz

tar xzf microbe-refseq-sbt-k51-2017.05.09.tar.gz
tar xzf microbe-refseq-sbt-k31-2017.05.09.tar.gz
tar xzf microbe-refseq-sbt-k21-2017.05.09.tar.gz
tar xzf microbe-genbank-sbt-k51-2017.05.09.tar.gz
tar xzf microbe-genbank-sbt-k31-2017.05.09.tar.gz
tar xzf microbe-genbank-sbt-k21-2017.05.09.tar.gz

rm -r microbe-refseq-sbt-k51-2017.05.09.tar.gz
rm -r microbe-refseq-sbt-k31-2017.05.09.tar.gz
rm -r microbe-refseq-sbt-k21-2017.05.09.tar.gz
rm -r microbe-genbank-sbt-k51-2017.05.09.tar.gz

cd ../
```

If you don't already have the trimmed data you can download it from OSF:

```
wget https://osf.io/tzkjr/download -O SRR606249_1.trim2.fq.gz
wget https://osf.io/sd968/download -O SRR606249_2.trim2.fq.gz
wget https://osf.io/acs5k/download -O SRR606249_subset50_1.trim2.fq.gz
wget https://osf.io/bem28/download -O SRR606249_subset50_2.trim2.fq.gz
wget https://osf.io/syf3m/download -O SRR606249_subset25_1.trim2.fq.gz
wget https://osf.io/zbcrx/download -O SRR606249_subset25_2.trim2.fq.gz
wget https://osf.io/ksu3e/download -O SRR606249_subset10_1.trim2.fq.gz
wget https://osf.io/k9tqn/download -O SRR606249_subset10_2.trim2.fq.gz
wget https://osf.io/qtzyk/download -O SRR606249_1.trim30.fq.gz
wget https://osf.io/dumz6/download -O SRR606249_2.trim30.fq.gz
wget https://osf.io/v5jhs/download -O SRR606249_subset50_1.trim30.fq.gz
wget https://osf.io/q4cfa/download -O SRR606249_subset50_2.trim30.fq.gz
wget https://osf.io/jcp5n/download -O SRR606249_subset25_1.trim30.fq.gz
wget https://osf.io/qevh9/download -O SRR606249_subset25_2.trim30.fq.gz
wget https://osf.io/rtvuz/download -O SRR606249_subset10_1.trim30.fq.gz
wget https://osf.io/zq4f9/download -O SRR606249_subset10_2.trim30.fq.gz
```

Next, calculate signatures for our data:

```
sourmashurl="quay.io/biocontainers/sourmash:2.0.0a3--py36_0"

for filename in *_1.trim2.fq.gz
do
    #Remove _1.trim.fq from file name to create base
    base=$(basename $filename _1.trim2.fq.gz)
    sigsuffix=".trim2.scaled10k.k21_31_51.sig"
    echo $base

    if [ -f ${base}${sigsuffix} ]
    then
        # skip
        echo "Skipping file ${base}${sigsuffix}, file exists."
    else
        docker run \
            -v ${PWD}:/data \
            ${sourmashurl} \
            sourmash compute \
            --merge /data/${base}.trim2.fq.gz \
            --track-abundance \
            --scaled 10000 \
            -k 21,31,51 \
            /data/${base}_1.trim2.fq.gz \
            /data/${base}_2.trim2.fq.gz \
            -o /data/${base}${sigsuffix}
    fi
done

for filename in *_1.trim30.fq.gz
do
    #Remove _1.trim.fq from file name to create base
    base=$(basename $filename _1.trim30.fq.gz)
    sigsuffix=".trim30.scaled10k.k21_31_51.sig"
    echo $base

    if [ -f ${base}${sigsuffix} ]
    then
        # skip
        echo "Skipping file ${base}${sigsuffix}, file exists."
    else
        docker run \
            -v ${PWD}:/data \
            ${sourmashurl} \
            sourmash compute \
            --merge /data/${base}.trim30.fq.gz \
            --track-abundance \
            --scaled 10000 \
            -k 21,31,51 \
            /data/${base}_1.trim30.fq.gz \
            /data/${base}_2.trim30.fq.gz \
            -o /data/${base}${sigsuffix}
    fi
done

```

And compare those signatures to our database to classify the components.

```
sourmashurl="quay.io/biocontainers/sourmash:2.0.0a3--py36_0"
for kmer_len in 21 31 51
do
    for sig in *sig
    do
        docker run \
            -v ${PWD}:/data \
            ${sourmashurl} \
            sourmash gather \
            -k ${kmer_len} \
            ${sig} \
            genbank-k${kmer_len}.sbt.json \
            refseq-k${kmer_len}.sbt.json \
            -o ${sig}.k${kmer_len}.gather.output.csv \
            --output-unassigned ${sig}.k${kmer_len}gather_unassigned.output.csv \
            --save-matches ${sig}.k${kmer_len}.gather_matches
    done
done
```

Now, let's download and unpack the kaiju database (this takes about 15 minutes on my machine):

```
kaijudir="${PWD}/kaijudb"
tarfile="kaiju_index_nr_euk.tgz"

mkdir ${kaijudir}
curl -LO "http://kaiju.binf.ku.dk/database/${tarfile}"
tar xzf ${tarfile}
rm -f ${tarfile}
```

and then link the data and run kaiju:

```
for filename in *1.trim2.fq.gz
do
    #Remove _1.trim2.fq from file name to create base
    base=$(basename $filename _1.trim2.fq.gz)
    echo $base

    # Command to run container interactively:
    #docker run -it --rm -v ${PWD}:/data quay.io/biocontainers/kaiju:1.6.1--pl5.22.0_0 /bin/bash

    docker run \
        -v ${PWD}:/data \
        quay.io/biocontainers/kaiju:1.6.1--pl5.22.0_0 \
        kaiju \
        -x \
        -v \
        -t /data/kaijudb/nodes.dmp \
        -f /data/kaijudb/kaiju_db_nr_euk.fmi \
        -i /data/${base}_1.trim2.fq.gz \
        -j /data/${base}_2.trim2.fq.gz \
        -o /data/${base}.kaiju_output.trim2.out \
        -z 4
done

for filename in *1.trim30.fq.gz
do
    #Remove _1.trim30.fq from file name to create base
    base=$(basename $filename _1.trim30.fq.gz)
    echo $base

    docker run \
        -v ${PWD}:/data \
        quay.io/biocontainers/kaiju:1.6.1--pl5.22.0_0 \
        kaiju \
        -x \
        -v \
        -t /data/kaijudb/nodes.dmp \
        -f data/kaijudb/kaiju_db_nr_euk.fmi \
        -i /data/${base}_1.trim30.fq.gz \
        -j /data/${base}_2.trim30.fq.gz \
        -o /data/${base}.kaiju_output.trim30.out \
        -z 4
done
```

Convert kaiju output to format readable by krona:

```
kaijuurl="quay.io/biocontainers/kaiju:1.6.1--pl5.22.0_0"
kaijudir="kaijudb"
for i in *trim{"2","30"}.out
do
    docker run \
        -v ${PWD}:/data \
        ${kaijuurl} \
        kaiju2krona \
        -v \
        -t \
        /data/${kaijudir}/nodes.dmp \
        -n /data/${kaijudir}/names.dmp \
        -i /data/${i} \
        -o /data/${i}.kaiju.out.krona
done

for i in *trim{"2","30"}.out
do
    docker run \
        -v ${PWD}:/data \
        ${kaijuurl} \
        kaijuReport \
        -v \
        -t \
        /data/${kaijudir}/nodes.dmp \
        -n /data/${kaijudir}/names.dmp \
        -i /data/${i} \
        -r genus \
        -o /data/${i}.kaiju_out_krona.summary 
done

```

Now let's filter out taxa with low abundances by obtaining genera that comprise at least 1 percent of the total reads:

```
kaijuurl="quay.io/biocontainers/kaiju:1.6.1--pl5.22.0_0"
for i in *trim{"2","30"}.out
do
    docker run \
        -v ${PWD}:/data \
        ${kaijuurl} \
        kaijuReport 
        -v \
        -t /data/kaijudb/nodes.dmp \
        -n /data/kaijudb/names.dmp \
        -i /data/${i} \
        -r genus \
        -m 1 \
        -o /data/${i}.kaiju_out_krona.1percenttotal.summary
done
```

Now for comparison, let's take the genera that comprise at least 1 percent of all of the classified reads:

```
for i in *trim{"2","30"}.out
do
    docker run \
        -v ${PWD}:/data \
        ${kaijuurl} \
        kaijuReport \
        -v \
        -t /data/kaijudb/nodes.dmp \
        -n /data/kaijudb/names.dmp \
        -i /data/${i} \
        -r genus \
        -m 1 \
        -u \
        -o /data/${i}.kaiju_out_krona.1percentclassified.summary
done
```

Download the krona image from quay.io so we can visualize the results from kaiju:

```
kaijudir="${PWD}/kaijudb"
suffix="kaiju_out_krona"
kronaurl="quay.io/biocontainers/krona:2.7--pl5.22.0_1"
docker pull ${kronaurl}
```

Generate krona html with output from all of the reads:

```
suffix="kaiju_out_krona"
for i in *${suffix}.summary
do
        docker run \
            -v ${kaijudir}:/data \
            ${kronaurl} \
            ktImportText \
            -o /data/${i}.${suffix}.html \
            /data/${i}
done
```

Generate krona html with output from genera at least 1 percent of the total reads:

```
suffix="kaiju_out_krona.1percenttotal"
for i in *${suffix}.summary
do
        docker run \
            -v ${kaijudir}:/data \
            ${kronaurl} \
            ktImportText \
            -o /data/${i}.${suffix}.html \
            /data/${i}
done
```

Generate krona html with output from genera at least 1 percent of all classified reads:

```
suffix="kaiju_out_krona.1percentclassified"
for i in *${suffix}.summary
do
        docker run \
            -v ${kaijudir}:/data \
            ${kronaurl} \
            ktImportText \
            -o /data/${i}.${suffix}.html \
            /data/${i}
done
```

