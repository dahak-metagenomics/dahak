 Taxonomic classification

#### from unbuntu 16.04 using filtered reads

#### Sourmash is a tool for calculating and comparing MinHash signatures. Sourmash gather allows us taxonomically calssify the componen$
```
cd ~/data
curl -O https://s3-us-west-1.amazonaws.com/spacegraphcats.ucdavis.edu/microbe-refseq-sbt-k51-2017.05.09.tar.gz
tar -zxvf microbe-refseq-sbt-k51-2017.05.09.tar.gz
curl -O https://s3-us-west-1.amazonaws.com/spacegraphcats.ucdavis.edu/microbe-genbank-sbt-k51-2017.05.09.tar.gz
tar xzf microbe-refseq-sbt-k51-2017.05.09.tar.gz
tar xzf microbe-genbank-sbt-k51-2017.05.09.tar.gz
rm -r microbe-refseq-sbt-k51-2017.05.09.tar.gz
rm -r microbe-genbank-sbt-k51-2017.05.09.tar.gz
```
#### Now, download the containers
```
docker pull quay.io/biocontainers/sourmash:2.0.0a1--py35_2
docker pull quay.io/biocontainers/kaiju:1.5.0--pl5.22.0_0
docker pull quay.io/biocontainers/kraken:0.10.6_eaf8fb68--pl5.22.0_4
```
#### Next, calculate signatures for our data
```
for i in
do
        docker run -v /home/ubuntu/data:/data quay.io/biocontainers/sourmash:2.0.0a1--py35_2 sourmash compute \
        --scaled 10000 -k 51 /data/${i} -o /data/${i}.scaled10k.k51.sig
done
```
#### And compare those signatures to our database to classify the components.
```
for i in *trim2*sig
do
        docker run -v /home/ubuntu/data:/data quay.io/biocontainers/sourmash:2.0.0a1--py35_2 sourmash gather \
        -k 51 /data/${i} /data/genbank-k51.sbt.json /data/refseq-k51.sbt.json -o /data/${i}gather.output.csv
done
```
#### Now, let's download and unpack the kaiju database
```
mkdir kaijudb
cd kaijudb
curl -LO http://kaiju.binf.ku.dk/database/kaiju_index_nr_euk.tgz
tar zxvf kaiju_index_nr_euk.tgz
rm -r kaiju_index_nr_euk.tgz
```
mkdir kaijudb
cd kaijudb
curl -LO http://kaiju.binf.ku.dk/database/kaiju_index_nr_euk.tgz
tar zxvf kaiju_index_nr_euk.tgz
rm -r kaiju_index_nr_euk.tgz

```
#### unzip file for processing
```
cd ~/data
gunzip *.trim.fq.gz
```
#### and then link the data and run kaiju
```
for filename in *_1.trim.fq
do

        #Remove _1.trim.fq from file name to create base
        base=$(basename $filename _1.trim.fq)
        echo $base

        docker run -v /home/ubuntu/data:/data quay.io/biocontainers/kaiju:1.5.0--pl5.22.0_0 kaiju -v -t \
        /data/kaijudb/nodes.dmp -f data/kaijudb/kaiju_db.fmi -i /data/${base}_1.trim.fq -j /data/${base}_2.trim.fq -o /data/${base}.kai$

done
```
#### GZIP the fastq files
```
gzip *trim.fq
```
#### Convert file kaiju file to format readable by krona
```
for i in *trim2.out
do
        docker run -v /home/ubuntu/data:/data quay.io/biocontainers/kaiju:1.5.0--pl5.22.0_0 kaiju2krona -v -t \
        /data/kaijudb/nodes.dmp -n /data/kaijudb/names.dmp -i /data/${i} -o /data/${i}.kaiju.out.krona
done
```
#### Convert kaiju output
```
for i in *trim2.out
do
        docker run -v /home/ubuntu/data:/data quay.io/biocontainers/kaiju:1.5.0--pl5.22.0_0 kaijuReport -v -t \
        /data/kaijudb/nodes.dmp -n /data/kaijudb/names.dmp -i /data/${i} -r genus -o /data/${i}.kaiju_out_krona.summary
done
```
#### filter out taxa with low abundances, e.g. for only showing genera that comprise at least 1 percent of the total reads:
```
for i in *trim2.out
do
        docker run -v /home/ubuntu/data:/data quay.io/biocontainers/kaiju:1.5.0--pl5.22.0_0 kaijuReport -v -t \
        /data/kaijudb/nodes.dmp -n /data/kaijudb/names.dmp -i /data/${i}  -r genus -m 1 -o /data/${i}.kaiju_out_krona.1percenttotal.summary
	```
#### genera comprising at least 1 percent of all classified reads
```
for i in *trim2.out
do
        docker run -v /home/ubuntu/data:/data quay.io/biocontainers/kaiju:1.5.0--pl5.22.0_0 kaijuReport -v -t \
        /data/kaijudb/nodes.dmp -n /data/kaijudb/names.dmp -i /data/${i} -r \
        genus -m 1 -u -o /data/${i}.kaiju_out_krona.1percentclassified.summary
done
```
#### Download the krona image
```
docker pull quay.io/biocontainers/krona:2.7--pl5.22.0_1
```
#### Execute krona with all of the reads
```
for i in *1percenttotal.summary
do
        docker run -v /home/ubuntu/data:/data quay.io/biocontainers/krona:2.7--pl5.22.0_1 ktImportText -o \
        /data/${i}.kaiju_out_krona.trim.out.all.html /data/${i}
done
```
#### Execute krona with 1 percent of the total reads
```
for i in *1percenttotal.html
do
        docker run -v /home/ubuntu/data:/data quay.io/biocontainers/krona:2.7--pl5.22.0_1 ktImportText -o \
        /data/${i}.kaiju_out_krona.1percenttotal.html /data/${i}
done
```
#### Execute krona with genera comprising at least 1 percent of all classified reads
```
for i in *1percentclassified.summary
do
        docker run -v /home/ubuntu/data:/data quay.io/biocontainers/krona:2.7--pl5.22.0_1 ktImportText -o \
        /data/${i}.kaiju_out_krona.1percentclassified.html /data/${i}

done
```
#### Execute krona with 1 percent of the total reads
```
for i in *1percenttotal.html
do
        docker run -v /home/ubuntu/data:/data quay.io/biocontainers/krona:2.7--pl5.22.0_1 ktImportText -o \
        /data/${i}.kaiju_out_krona.1percenttotal.html /data/${i}
done
```
#### Execute krona with genera comprising at least 1 percent of all classified reads
```
for i in *1percentclassified.summary
do
        docker run -v /home/ubuntu/data:/data quay.io/biocontainers/krona:2.7--pl5.22.0_1 ktImportText -o \
        /data/${i}.kaiju_out_krona.1percentclassified.html /data/${i}

done
```




