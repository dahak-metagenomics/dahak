# Functional  

#### from unbuntu 16.04 using filtered reads

#### first, grab the ABRicate container
```
docker pull thanhleviet/abricate abricate
```
#### next, link the data and run Abricate
#### MegaHit contigs 
```
docker run -v /home/ubuntu/data:/data -it thanhleviet/abricate abricate /data/megahit_output_podar_metaG_sub_10/final.contigs.fa > abricate_output_megahit_podar_metaG_sub_10.tab
```
#### SPAdes contigs 
```
docker run -v /home/ubuntu/data:/data -it thanhleviet/abricate abricate /data/spades_output_podar_metaG_sub_10/contigs.fasta > abricate_output_spades.tab
```
