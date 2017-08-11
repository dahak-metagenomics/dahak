#### from ubuntu 16.04 using filtered reads

```
docker pull quay.io/biocontainers/megahit:1.1.1--py36_0
docker pull quay.io/biocontainers/spades:3.10.1--py27_0
docker pull quay.io/biocontainers/quast:4.5--boost1.61_1
docker pull quay.io/biocontainers/prokka:1.11--0
```
```
tmux 
```
#### link the data and run Megahit
```
docker run -v /home/ubuntu/data:/data -it quay.io/biocontainers/megahit:1.1.1--py36_0 megahit --12 /data/SRR606249_subset10.pe.trim.fq.gz -o /data/megahit_output_podar_metaG_sub_10
```
#### Now run quast to generate some assembly statistics 
```
docker run -v /home/ubuntu/data:/data -it quay.io/biocontainers/quast:4.5--boost1.61_1 quast.py /data/megahit_output_podar_metaG_sub_10/final.contigs.fa -o /data/megahit_output_podar_metaG_sub_10_quast_report
```
#### link the data and run SPAdes 
```
docker run -v /home/ubuntu/data:/data -it quay.io/biocontainers/spades:3.10.1--py27_0 metaspades.py --12 /data/SRR606249_subset10.pe.trim.fq.gz \
	-o /data/spades_output_podar_metaG_sub_10
```
#### Now run quast to generate some assembly statistics 
```
docker run -v /home/ubuntu/data:/data -it quay.io/biocontainers/quast:4.5--boost1.61_1 quast.py /data/spades_ouput_podar_metaG_sub_10/contigs.fasta -o data/spades_output__podar_metaG_sub_10_quast_report
```
#### Now annotate your contigs with prokka
```
docker run -v /home/ubuntu/data:/data -it quay.io/biocontainers/prokka:1.11--0 prokka /data/podar_metaG_sub_10/final.contigs.fa \
	--outdir /data/prokka_annotation --prefix podar_metaG_sub_10 
```
```
docker run -v /home/ubuntu/data:/data -it quay.io/biocontainers/prokka:1.11--0 prokka /data/spades_ouput_podar_metaG_sub_10/contigs.fasta \
	--outdir /data/prokka_annotation --prefix podar_metaG_sub_10 
```

