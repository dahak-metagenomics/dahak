Assembly with [SPAdes](http://bioinf.spbau.ru/spades) and [MEGAHIT](https://github.com/voutcn/megahit)
======================================================================================================
Requirements (from unbuntu 16.04 using filtered reads)

Disk space(60 gb)
RAM(32 gb)
Updated packages(see [read filtering](https://github.com/dahak-metagenomics/dahak/tree/master/workflows/read_filtering))
Docker(see [read filtering](https://github.com/dahak-metagenomics/dahak/tree/master/workflows/read_filtering) for installation instructions) 
```
docker pull quay.io/biocontainers/megahit:1.1.1--py36_0
docker pull quay.io/biocontainers/spades:3.10.1--py27_0
docker pull quay.io/biocontainers/quast:4.5--boost1.61_1
```
#### Link the data and run MEGAHIT
```
for filename in *.trim30.fq.gz
do 

	base=$(basename $filename .trim30.fq.gz)
	echo $base 

	docker run -v /home/ubuntu/data:/data -it quay.io/biocontainers/megahit:1.1.1--py36_0 \ 
	megahit --12 /data/${i} --out-prefix=${base} -o /data/${base}.megahit_output
done
```
#### Now run Quast to generate some assembly statistics 
```
for file in *.megahit_output/*contigs.fa
do

	base=$(basename $file .contigs.fa)
	echo $base 
	 
	docker run -v /home/ubuntu/data:/data -it quay.io/biocontainers/quast:4.5--boost1.61_1 \
	quast.py /data/${file} -o /data/${base}.megahit_quast_report
done
```
#### Link the data and run SPAdes  
```
for filename in *pe.trim30.fq.gz
do
	base=$(basename $filename .trim30.fq.gz)
	echo $base
	
	docker run -v /home/ubuntu/data:/data -it quay.io/biocontainers/spades:3.10.1--py27_0 \
	metaspades.py --12 /data/${filename} \
	-o /data/${base}.spades_output
done 
```
#### Now run Quast to generate some assembly statistics 
```
for file in *.spades_output
do 

	base=$(basename $file .spades_output)
	echo ${base}

	docker run -v /home/ubuntu/data:/data -it quay.io/biocontainers/quast:4.5--boost1.61_1 \
	quast.py /data/${base}.spades_output/contigs.fasta \
	-o data/${base}.spades_output_quast
done
```
