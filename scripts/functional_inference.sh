#!/bin/bash

cd ~/data 

mkdir ~/data/functional_inference
mkdir ~/data/functional_inference/antibiotic_resistance
mkdir ~/data/functional_inference/antibiotic_resistance/srst2
mkdir ~/data/functional_inference/antibiotic_resistance/abricate
mkdir ~/data/functional_inference/contig_annotations

#Annotate contigs with prokka
for i in *_spades_output/contigs.fasta
do

base=`echo ${i} | awk -F'[.]' '{print $1"."$2}'`
echo $base

docker run -v /home/ubuntu/data:/data -it ummidock/prokka:1.12 \
	prokka /data/${i} --outdir /data/functional_inference/contig_annotations/${base}_spades_output \
 	--prefix ${base}_spades_
done

for i in *_megahit_output/final.contigs.fa
do

base=`echo ${i} | awk -F'[.]' '{print $1"."$2}'`
echo $base

docker run -v /home/ubuntu/data:/data -it ummidock/prokka:1.12 \
    	prokka /data/${i} --outdir /data/functional_inference/contig_annotations\${base}_megahit_output \
	--prefix ${base}_megahit_
done

#Search antibiotic resistance genes using abricate

for i in *_spades_output/contigs.fasta
do

base=`echo ${i} | awk -F'[.]' '{print $1"."$2}'`
echo $base

docker run -v /home/ubuntu/data:/data -it thanhleviet/abricate abricate \
	/data/${i} > functional_inference/antibiotic_resistance/abricate/${base}_spades_abricate.tab
done

for i in *_megahit_output/final.contigs.fa
do

base=`echo ${i} | awk -F'[.]' '{print $1"."$2}'`
echo $base

docker run -v /home/ubuntu/data:/data -it thanhleviet/abricate abricate \
        /data/${i} > functional_inference/antibiotic_resistance/abricate/${base}_megahit_abricate.tab
done

#Search for antibiotic resistance genes using SRST2
osf -p dm938 fetch osfstorage/misc/ARGannot.r1.fasta

for filename in *_1.trim2.fq.gz
do

base=$(basename $filename _1.trim2.fq.gz)
echo $base

docker run -v /home/ubuntu/data:/data -it brooksph/srst2:latest \
	srst2 --input_pe /data/${base}_1.trim2.fq.gz /data/${base}_2.trim2.fq.gz \
	--forward _1.trim2 --reverse _2.trim2 \
	--output /data/functional_inference/antibiotic_resistance/srst2${filename} \
	--gene_db /data/ARGannot.r1.fasta
done

for filename in *_1.trim30.fq.gz
do

base=$(basename $filename _1.trim30.fq.gz)
echo $base

docker run -v /home/ubuntu/data:/data -it brooksph/srst2:latest \
	srst2 --input_pe /data/${base}_1.trim30.fq.gz /data/${base}_2.trim30.fq.gz \
	--forward _1.trim30 --reverse _2.trim30 \
        --output /data/functional_inference/antibiotic_resistance/srst2${filename} \
	--gene_db /data/ARGannot.r1.fasta
done
