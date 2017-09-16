# Taxonomic classification 

#### from unbuntu 16.04 using filtered reads

#### Sourmash is a tool for calculating and comparing MinHash signatures. Sourmash gather allows us taxonomically calssify the components of a metagenome by compairing MinHash signatures to a database. First, download the database. 
```
cd ~/data
curl -O https://s3-us-west-1.amazonaws.com/spacegraphcats.ucdavis.edu/microbe-refseq-sbt-k51-2017.05.09.tar.gz
tar xzf microbe-genbank-sbt-k51-2017.05.09.tar.gz
curl -O https://s3-us-west-1.amazonaws.com/spacegraphcats.ucdavis.edu/microbe-genbank-sbt-k51-2017.05.09.tar.gz
tar xzf microbe-genbank-sbt-k51-2017.05.09.tar.gz
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
<<<<<<< HEAD
	-k 51 /data/${i} /data/genbank-k51.sbt.json /data/refseq-k51.sbt.json -o /data/${i}gather.output.csv
=======
	-k 31 /data/${i} /data/genbank-k51.sbt.json /data/refseq- -o /data/${i}gather.output.csv
>>>>>>> fbeeb097d740f4a0799a4e8b9d202caf09976d4f
done
```
#### Now, let's download and unpack the kaiju database 
```
mkdir kaijudb
cd kaijudb 
curl -LO http://kaiju.binf.ku.dk/database/kaiju_index.tgz
tar zxvf kaiju_index.tgz
```
#### unzip file for processing 
```
cd ~/data
gunzip SRR606249_subset10.pe.trim.fq.gz
```
#### and then link the data and run kaiju
```
for i in SRR606249_subset10.pe.trim.fq.gz
do
docker run -v /home/ubuntu/data:/data quay.io/biocontainers/kaiju:1.5.0--pl5.22.0_0 kaiju -v -t /data/kaijudb/nodes.dmp -f data/kaijudb/kaiju_db.fmi -i /data/SRR606249_subset10.pe.trim.fq -o /data/kaiju_output_SRR606249_subset10_1.pe.trim.out -z 16
```
```
gzip SRR606249_subset10.pe.trim.fq 
```
```
docker run -v /home/ubuntu/data:/data quay.io/biocontainers/kaiju:1.5.0--pl5.22.0_0 kaiju2krona -v -t /data/kaijudb/nodes.dmp -n /data/kaijudb/names.dmp -i /data/kaiju_output_SRR606249_subset10_1.pe.trim.out -o /data/kaiju.out.krona_SRR606249_subset10_1.pe.trim.out 
```
```
docker run -v /home/ubuntu/data:/data quay.io/biocontainers/kaiju:1.5.0--pl5.22.0_0 kaijuReport -v -t /data/kaijudb/nodes.dmp -n /data/kaijudb/names.dmp -i /data/kaiju_output_SRR606249_subset10_1.pe.trim.out -r genus -o /data/kaiju_out_krona_SRR606249_subset10_1.pe.trim.out.summary
```
#### filter out taxa with low abundances, e.g. for only showing genera that comprise at least 1 percent of the total reads:
```
docker run -v /home/ubuntu/data:/data quay.io/biocontainers/kaiju:1.5.0--pl5.22.0_0 kaijuReport -v -t /data/kaijudb/nodes.dmp -n /data/kaijudb/names.dmp -i /data/kaiju_output_SRR606249_subset10_1.pe.trim.out  -r genus -m 1 -o /data/kaiju_out_krona_SRR606249_subset10_1.pe.trim.out.1percenttotal.summary
```
#### genera comprising at least 1 percent of all classified reads
```
docker run -v /home/ubuntu/data:/data quay.io/biocontainers/kaiju:1.5.0--pl5.22.0_0 kaijuReport -v -t /data/kaijudb/nodes.dmp -n /data/kaijudb/names.dmp -i /data/kaiju_output_SRR606249_subset10_1.pe.trim.out  -r genus  -m 1 -u -o /data/kaiju_out_krona_SRR606249_subset10_1.pe.trim.out.1percentclassified.summary
```
#### Download the krona image
```
docker pull quay.io/biocontainers/krona:2.7--pl5.22.0_1
```
#### Execute krona with all of the reads 
```
docker run -v /home/ubuntu/data:/data quay.io/biocontainers/krona:2.7--pl5.22.0_1 ktImportText -o /data/kaiju_out_krona_SRR606249_subset10_1.pe.trim.out.all.html /data/kaiju_out_krona_SRR606249_subset10_1.pe.trim.out.summary
```
#### Execute krona with 1 percent of the total reads
```
docker run -v /home/ubuntu/data:/data quay.io/biocontainers/krona:2.7--pl5.22.0_1 ktImportText -o /data/kaiju_out_krona_SRR606249_subset10_1.pe.trim.out.1percenttotal.html /data/kaiju_out_krona_SRR606249_subset10_1.pe.trim.out.1percenttotal.summary
```
#### Execute krona with genera comprising at least 1 percent of all classified reads
```
docker run -v /home/ubuntu/data:/data quay.io/biocontainers/krona:2.7--pl5.22.0_1 ktImportText -o /data/kaiju_out_krona_SRR606249_subset10_1.pe.trim.out.1percentclassified.html /data/kaiju_out_krona_SRR606249_subset10_1.pe.trim.out.1percentclassified.summary
```
