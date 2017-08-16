# Taxonomic classification 

#### from unbuntu 16.04 using filtered reads

#### Sourmash is a tool for calculating and comparing MinHash signatures. Sourmash gather allows us taxonomically calssify the components of a metagenome by compairing MinHash signatures to a database. First, download the database. 
```
cd ~/data
curl -O https://s3-us-west-1.amazonaws.com/spacegraphcats.ucdavis.edu/microbe-genbank-sbt-k31-2017.05.09.tar.gz
tar xzf microbe-genbank-sbt-k31-2017.05.09.tar.gz
```
#### Now, download the container
```
docker pull quay.io/biocontainers/sourmash:2.0.0a1--py35_2
docker pull quay.io/biocontainers/kaiju:1.5.0--pl5.22.0_0
docker pull quay.io/biocontainers/kraken:0.10.6_eaf8fb68--pl5.22.0_4
```
#### Next, calculate a signature for our data
```
docker run -v /home/ubuntu/data:/data quay.io/biocontainers/sourmash:2.0.0a1--py35_2 sourmash compute --scaled 10000 -k 31 /data/SRR606249_subset10.pe.trim.fq.gz -o /data/SRR606249_subset10.pe.trim.scaled10k.k31.sig
```
#### And compare that signature to our database to classify the components.
```
docker run -v /home/ubuntu/data:/data quay.io/biocontainers/sourmash:2.0.0a1--py35_2 sourmash gather -k 31 /data/SRR606249_subset10.pe.trim.scaled10k.k31.sig /data/genbank-k31.sbt.json -o /data/gather_output_SRR606249_subset10.pe.trim.scaled10k.csv
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
