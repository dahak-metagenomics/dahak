#### Metagenome comparison with [sourmash](http://sourmash.readthedocs.io/en/latest/)
Requirements (from Ubuntu 16.04 using filtered reads)

Sourmash is a tool for calculating and comparing MinHash signatures. Sourmash compare 
calculates the jaccard similarity of MinHash signatures.  	

If you don't already have them, retrieve the assembled contigs
```
for i in $(cat assembly_names.txt) 
do 

	osf -u philliptbrooks@gmail.com -p dm938 fetch ${i} ${i}
	echo ${i}
done  
```
Calculate sourmash signatures for reads
```
for filename in *_1.trim2.fq.gz
do
	#Remove _1.trim2.fq from file name to create base
	base=$(basename $filename _1.trim2.fq.gz)
	echo $base

	docker run -v /home/ubuntu/data:/data quay.io/biocontainers/sourmash:2.0.0a1--py35_2 sourmash compute \
		--merge /data/${base}.trim2.fq.gz \
		--scaled 10000 \
		-k 21,31,51 \
		/data/${base}_1.trim2.fq.gz \ 
		/data/${base}_2.trim2.fq.gz \
		-o /data/${base}.pe.trim2.fq.gz.k21_31_51.sig
done

for filename in *_1.trim30.fq.gz
do
	#Remove _1.trim30.fq from file name to create base
	base=$(basename $filename _1.trim30.fq.gz)
	echo $base

	docker run -v /home/ubuntu/data:/data quay.io/biocontainers/sourmash:2.0.0a1--py35_2 sourmash compute \
		--merge /data/${base}.trim30.fq.gz \
		--scaled 10000 \
		-k 21,31,51 \
		/data/${base}_1.trim30.fq.gz \
		/data/${base}_2.trim30.fq.gz \
		-o /data/${base}pe.trim30.fq.gz.k21_31_51.sig
done
```
Calculate sourmash signatures for assemblies  
```
for i in osfstorage/assembly/SRR606249{"_1","_subset10_1","_subset25_1","_subset50_1"}.trim{"2","30"}.fq.gz_megahit_output/final.contigs.fa
do     
	base=`echo ${i} | awk -F/ '{print $3}'`
	echo ${base}
    
	docker run -v ${PWD}:/data quay.io/biocontainers/sourmash:2.0.0a1--py35_2 sourmash \
    		compute \ 
    		-k 21,31,51 \ 
    		--scaled 10000 \
    		/data/${i} \
    		-o /data/${base}.k21_31_51.sig
done 

for i in osfstorage/assembly/SRR606249{"_1","_subset10_1","_subset25_1","_subset50_1"}.trim{"2","30"}.fq.gz_spades_output/contigs.fasta
do     
        base=`echo ${i} | awk -F/ '{print $3}'`
        echo ${base}

        docker run -v ${PWD}:/data quay.io/biocontainers/sourmash:2.0.0a1--py35_2 sourmash \
        	compute \
        	-k 21,31,51 \
        	--scaled 10000 \
        	/data/${i} \
        	-o /data/${base}.k21_31_51.sig
done
```
for i in 21 31 51 
do 

    	docker run -v ${PWD}:/data quay.io/biocontainers/sourmash:2.0.0a1--py35_2 sourmash \
    		compare /data/SRR606249.pe.trim2.fq.gz.k21_31_51.sig \
    		/data/SRR606249.pe.trim30.fq.gz.k21_31_51.sig \
    		/data/SRR606249_subset10.pe.trim2.fq.gz.k21_31_51.sig \
    		/data/SRR606249_subset10.pe.trim30.fq.gz.k21_31_51.sig \
    		/data/SRR606249_subset25.pe.trim2.fq.gz.k21_31_51.sig \
    		/data/SRR606249_subset25.pe.trim30.fq.gz.k21_31_51.sig \
    		/data/SRR606249_subset50.pe.trim2.fq.gz.k21_31_51.sig \
    		/data/SRR606249_subset50.pe.trim30.fq.gz.k21_31_51.sig \
    		-k ${i} \
    		--csv /data/SRR606249.pe.trim2and30_comparison.k${i}.csv
done
```
#### To compare sourmash signatures from assemblies 
```
for i in 21 31 51 
do 
	docker run -v ${PWD}:/data quay.io/biocontainers/sourmash:2.0.0a1--py35_2 sourmash \
		compare /data/SRR606249_1.trim2.fq.gz_megahit_output.k21_31_51.sig \
		/data/SRR606249_1.trim2.fq.gz_spades_output.k21_31_51.sig \
		/data/SRR606249_1.trim30.fq.gz_megahit_output.k21_31_51.sig \
		/data/SRR606249_1.trim30.fq.gz_spades_output.k21_31_51.sig \
		/data/SRR606249_subset10_1.trim2.fq.gz_megahit_output.k21_31_51.sig \
		/data/SRR606249_subset10_1.trim2.fq.gz_spades_output.k21_31_51.sig \
		/data/SRR606249_subset10_1.trim30.fq.gz_megahit_output.k21_31_51.sig \
		/data/SRR606249_subset10_1.trim30.fq.gz_megahit_output.k21_31_51.sig \
		/data/SRR606249_subset25_1.trim2.fq.gz_megahit_output.k21_31_51.sig \
		/data/SRR606249_subset25_1.trim2.fq.gz_megahit_output.k21_31_51.sig \
		/data/SRR606249_subset25_1.trim30.fq.gz_megahit_output.k21_31_51.sig \
		/data/SRR606249_subset25_1.trim30.fq.gz_megahit_output.k21_31_51.sig \
		/data/SRR606249_subset50_1.trim2.fq.gz_megahit_output.k21_31_51.sig \
		/data/SRR606249_subset50_1.trim2.fq.gz_megahit_output.k21_31_51.sig \
		/data/SRR606249_subset50_1.trim30.fq.gz_megahit_output.k21_31_51.sig \
		/data/SRR606249_subset50_1.trim30.fq.gz_megahit_output.k21_31_51.sig \
		-k ${i} \
		--csv /data/SRR606249.pe.trim2and30_megahitandspades_comparison.k${i}.csv
done
```
