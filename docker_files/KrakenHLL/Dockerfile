FROM centos:latest
LABEL maintainer="cgrahlmann@signaturescience.com"

RUN yum update -y && yum install -y curl wget zlib-devel boost-devel time perl perl-File-Fetch perl-autodie perl-IO-Compress \
perl-LWP-Protocol-https.noarch perl-LWP-MediaTypes.noarch perl-LWP-Authen-Negotiate.noarch perl-LWP-Protocol-PSGI.noarch \
perl-LWP-Protocol-http10.noarch perl-LWP-UserAgent-DNS-Hosts.noarch perl-LWP-UserAgent-Determined.noarch
RUN yum groupinstall -y 'Development Tools'

#krakenhill source code
RUN git clone https://github.com/fbreitwieser/krakenhll
WORKDIR /krakenhll
RUN ./install_krakenhll.sh -j /kraken


ARG db_type=standard
WORKDIR /kraken
RUN mkdir db
RUN if [ $db_type = standard ] ; then ./krakenhll-build --standard --threads $(nproc) --db /kraken/db; else \
    ./krakenhll-build --download-library $db_type --db /kraken/db;
    fi
RUN ./krakenhll-build --db /kraken/db --clean


