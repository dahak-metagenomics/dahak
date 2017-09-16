From Ubuntu 16.04 

To compare sourmash signatures from raw reads 
```
docker run -v /home/ubuntu/data:/data quay.io/biocontainers/sourmash:2.0.0a1--py35_2 sourmash \
compare /data/SRR606249.pe.trim2.fq.gz.scaled10k.k51.sig \
/data/SRR606249_subset10.pe.trim2.fq.gz.scaled10k.k51.sig \
/data/SRR606249_subset25.pe.trim2.fq.gz.scaled10k.k51.sig \
/data/SRR606249_subset50.pe.trim2.fq.gz.scaled10k.k51.sig \
--csv /data/skakya_reads_trim2_comparison.csv
```
To compare sourmash signatures from assemblies 
```
docker run -v ~/home/ubuntu/data:/data quay.io/biocontainers/sourmash:2.0.0a1--py35_2 sourmash \
compare /comparison/megahit_output_podar_metaG_subset_10.sig \
/data/megahit_output_podar_metaG_subset_50.sig \
/data/spades_output_podar_metaG_subset_25.sig \
/data/megahit_output_podar_metaG_subset_25.sig \
/data/spades_output_podar_metaG_subset_10.sig \
/data/spades_output_podar_metaG_subset_50.sig \
/data/megahit_output_podar_metaG_subset_100.sig \
/comparison/spades_output_podar_metaG_subset_100.sig \
--csv /data/metaG_comparison.csv
```
