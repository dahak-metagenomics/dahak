	docker run -it ubuntu:14.04

	exit

	cd /Users/philliptbrooks/Dropbox/metagenome_assembly/data/seq
	
Put the following in a shell script 

	cat <<EOF > do-assemble.sh
	#! /bin/bash
	rm -fr /data/output
	/home/megahit/megahit --12 /mydata/*.pe.fq.gz -o /mydata/output 
	EOF
	

	chmod +x do-assemble.sh
	

Check it out 

	cat do-assemble.sh
	

Make directory for dockerfile 

	mkdir /Users/philliptbrooks/Dropbox/metagenome_assembly/make_megahit
	cd /Users/philliptbrooks/Dropbox/metagenome_assembly/make_megahit
	
Make docker file 

	cat <<EOF > Dockerfile
	FROM ubuntu:14.04
	RUN apt-get update
	RUN apt-get install -y g++ make git zlib1g-dev python
	RUN git clone https://github.com/voutcn/megahit.git /home/megahit
	RUN cd /home/megahit && make
	CMD /mydata/do-assemble.sh
	EOF

Check it out 

	cat Dockerfile

Build docker image 

	docker build -t megahit_ctr .

Test it 

	docker run -it megahit_ctr /home/megahit/megahit -h 
	
Move into directory for assembly
	
	cd /Users/philliptbrooks/Dropbox/metagenome_assembly/data/seq

Link data to docker image and run 

	docker run -v /Users/philliptbrooks/Dropbox/metagenome_assembly/data/seq:/mydata megahit_ctr

