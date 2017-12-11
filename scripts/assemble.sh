#!/bin/bash


#### from ubuntu 16.04 using filtered reads
docker pull quay.io/biocontainers/megahit:1.1.1--py36_0
docker pull quay.io/biocontainers/spades:3.11.1--py36_zlib1.2.8_0
docker pull quay.io/biocontainers/quast:4.5--boost1.61_1d
docker pull thanhleviet/abricate abricate
docker pull ummidock/prokka:1.12

#### link the data and run Megahit
for filename in *_1.trim2.fq.gz
do

base=$(basename $filename _1.trim2.fq.gz)
echo $base 

docker run -v /home/ubuntu/data:/data -it quay.io/biocontainers/megahit:1.1.1--py36_0 \
    megahit -1 /data/${base}_1.trim2.fq.gz -2 /data/${base}_2.trim2.fq.gz -o /data/${filename}_megahit_output
done


for filename in *_1.trim30.fq.gz
do

base=$(basename $filename _1.trim30.fq.gz)
echo $base 

docker run -v /home/ubuntu/data:/data -it quay.io/biocontainers/megahit:1.1.1--py36_0 \
    megahit -1 /data/${base}_1.trim30.fq.gz -2 /data/${base}_2.trim30.fq.gz -o /data/${filename}_megahit_output
done



#### Now run quast to generate some assembly statistics 
for i in *megahit_output/final.contigs.fa
do 

base=`echo ${i} | awk -F'[.]' '{print $1"."$2}'`
echo $base

docker run -v /home/ubuntu/data:/data -it quay.io/biocontainers/quast:4.5--boost1.61_1 \
    quast.py /data/${i} -o /data/${base}_quast_report
done

#### link the data and run SPAdes 
for filename in *_1.trim2.fq.gz
do

base=$(basename $filename _1.trim2.fq.gz)
echo $base

docker run -v /home/ubuntu/data:/data -it quay.io/biocontainers/spades:3.11.1--py36_zlib1.2.8_0 \
    metaspades.py -t 64 -1 /data/${base}_1.trim2.fq.gz -2 /data/${base}_2.trim2.fq.gz -o /data/${filename}_spades_output
done

for filename in *_1.trim30.fq.gz
do

base=$(basename $filename _1.trim30.fq.gz)
echo $base

docker run -v /home/ubuntu/data:/data -it quay.io/biocontainers/spades:3.11.1--py36_zlib1.2.8_0 \
    metaspades.py -t 64 -1 /data/${base}_1.trim30.fq.gz -2 /data/${base}_2.trim30.fq.gz -o /data/${filename}_spades_output
done

#### Now run quast to generate some assembly statistics 
for i in *_spades_output/contigs.fasta
do 

base=`echo ${i} | awk -F'[.]' '{print $1"."$2}'`
echo $base

docker run -v /home/ubuntu/data:/data -it quay.io/biocontainers/quast:4.5--boost1.61_1 \
    quast.py /data/${i} -o data/${basde}_quast_report
done 

