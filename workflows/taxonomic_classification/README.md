#### Taxonomic classification using [sourmash](http://sourmash.readthedocs.io/en/latest/) and [kaiju](http://kaiju.binf.ku.dk) 

#### Requirements (from unbuntu 16.04 using filtered reads)
- Disk space(120 gb)
- RAM(32 gb)
- Updated packages(see read filtering)
- Docker(see read filtering for installation instructions)
- osf cli(see read filtering for installation instructions)

#### Sourmash is a tool for calculating and comparing MinHash signatures. Sourmash gather allows us to taxonomically classify the components of a metagenome by comparing hashes in our dataset to hashes in a sequence bloom tree (sbt) representing genomes. First, let's download two sbts containing hashes that represent the microbial genomes in the NCBI GenBank and RefSeq databases. 
```
mkdir data
cd ~/data
curl -O https://s3-us-west-1.amazonaws.com/spacegraphcats.ucdavis.edu/microbe-refseq-sbt-k51-2017.05.09.tar.gz
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
#### If you don't already have the trimmed data you can download it from osf using the following command. First, you will need to copy trimmed_files.txt to your working directory or provide the path to this file. 
```
for i in $(cat trimmed_files.txt) 
do 
	osf -u philliptbrooks@gmail.com -p dm938 fetch osfstorage/data/${i} 
done 
```
#### Next, calculate signatures for our data
```
for filename in *_1.trim.fq.gz
do
	#Remove _1.trim.fq from file name to create base
	base=$(basename $filename _1.trim.fq.gz)
	echo $base

	docker run -v /home/ubuntu/data:/data quay.io/biocontainers/sourmash:2.0.0a1--py35_2 sourmash compute \
	--merge /data/${base}.trim.fq.gz --scaled 10000 -k 51 /data/${base}_1.trim.fq.gz /data/${base}_2.trim.fq.gz -o /data/${base}.scaled10k.k51.sig
done
```
#### And compare those signatures to our database to classify the components.
```
for i in *sig
do
	docker run -v /home/ubuntu/data:/data quay.io/biocontainers/sourmash:2.0.0a1--py35_2 sourmash gather \
	-k 51 /data/${i} /data/genbank-k51.sbt.json /data/refseq-k51.sbt.json -o /data/${i}gather.output.csv
done
```
#### Now, let's download and unpack the kaiju database (this takes about 15 minutes on my machine)
```
mkdir kaijudb
cd kaijudb
curl -LO http://kaiju.binf.ku.dk/database/kaiju_index_nr_euk.tgz
tar zxvf kaiju_index_nr_euk.tgz
rm -r kaiju_index_nr_euk.tgz
```
#### unzip files for processing using kaiju
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
	/data/kaijudb/nodes.dmp -f data/kaijudb/kaiju_db_nr_euk.fmi -i /data/${base}_1.trim.fq -j \
	/data/${base}_2.trim.fq -o /data/${base}.kaiju_output.trim2.out -z 16
done
```
#### GZIP the fastq files
```
gzip *trim.fq
```
#### Convert kaiju output to format readable by krona
```
for i in *trim2.out
do
	docker run -v /home/ubuntu/data:/data quay.io/biocontainers/kaiju:1.5.0--pl5.22.0_0 kaiju2krona -v -t \
	/data/kaijudb/nodes.dmp -n /data/kaijudb/names.dmp -i /data/${i} -o /data/${i}.kaiju.out.krona
done
```
#### Convert kaiju file to format readable by krona
```
for i in *trim2.out
do
	docker run -v /home/ubuntu/data:/data quay.io/biocontainers/kaiju:1.5.0--pl5.22.0_0 kaijuReport -v -t \
	/data/kaijudb/nodes.dmp -n /data/kaijudb/names.dmp -i /data/${i} -r genus -o /data/${i}.kaiju_out_krona.summary 
done
```
#### Now let's filter out taxa with low abundances by obtaining genera that comprise at least 1 percent of the total reads
```
for i in *trim2.out
do
        docker run -v /home/ubuntu/data:/data quay.io/biocontainers/kaiju:1.5.0--pl5.22.0_0 kaijuReport -v -t \
        /data/kaijudb/nodes.dmp -n /data/kaijudb/names.dmp -i /data/${i} -r \
	genus -m 1 -o /data/${i}.kaiju_out_krona.1percenttotal.summary
done
```
#### Now for comparison let's take the genera that comprise at least 1 percent of all of the classified reads
```
for i in *trim2.out
do
        docker run -v /home/ubuntu/data:/data quay.io/biocontainers/kaiju:1.5.0--pl5.22.0_0 kaijuReport -v -t \
        /data/kaijudb/nodes.dmp -n /data/kaijudb/names.dmp -i /data/${i} -r \
        genus -m 1 -u -o /data/${i}.kaiju_out_krona.1percentclassified.summary
done
```
#### Download the krona image from quay.io so we can visulaize the results from kaiju 
```
docker pull quay.io/biocontainers/krona:2.7--pl5.22.0_1
```
#### Generate krona html with output from all of the reads
```
for i in *kaiju_out_krona.summary
do
        docker run -v /home/ubuntu/data:/data quay.io/biocontainers/krona:2.7--pl5.22.0_1 ktImportText -o \
        /data/${i}.kaiju_out_krona.all.html /data/${i}
done
```
#### Generate krona html with output from genera respresenting atleast 1 percent of the total reads
```
for i in *kaiju_out_krona.1percenttotal.summary
do
        docker run -v /home/ubuntu/data:/data quay.io/biocontainers/krona:2.7--pl5.22.0_1 ktImportText -o \
        /data/${i}.kaiju_out_krona.1percenttotal.html /data/${i}
done
```
#### Generate krona html with output from genera respresenting atleast 1 percent of all classified reads
```
for i in *kaiju_out_krona.1percentclassified.summary
do
        docker run -v /home/ubuntu/data:/data quay.io/biocontainers/krona:2.7--pl5.22.0_1 ktImportText -o \
        /data/${i}.kaiju_out_krona.1percentclassified.html /data/${i}
done
```
