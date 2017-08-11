FROM ubuntu:16.04
RUN apt-get update --fix-missing
RUN apt-get upgrade -y 
RUN apt-get install -y emboss bioperl ncbi-blast+ gzip unzip \
  libjson-perl libtext-csv-perl libfile-slurp-perl liblwp-protocol-https-perl libwww-perl git
RUN git clone https://github.com/tseemann/abricate.git
RUN ./abricate/bin/abricate --check
RUN ./abricate/bin/abricate --setupdb
ENTRYPOINT abricate/bin/abricate
CMD abricate/bin/abricate

