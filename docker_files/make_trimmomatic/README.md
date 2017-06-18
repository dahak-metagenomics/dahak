Make directory for dockerfile 

	mkdir /Users/philliptbrooks/Dropbox/metagenome_assembly/make_trimmomatic
	cd /Users/philliptbrooks/Dropbox/metagenome_assembly/make_trimmomatic
	
Make docker file 

	cat <<EOF > Dockerfile
	FROM ubuntu:14.04
	RUN apt-get update && apt-get install -y trimmomatic 
	EOF

Check it out 

	cat Dockerfile

Build docker image 

	docker build -t trimmomatic_ctr .

Test it 

	docker run -it fastqc_ctr fastqc -h 
	
Move into directory for assembly
	
	cd "path to data"

Link data to docker image and run 

	docker run -v "path to data":/mydata fastqc_ctr


