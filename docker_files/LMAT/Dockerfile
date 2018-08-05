FROM centos:latest
LABEL maintainer="cgrahlmann@signaturescience.com"

RUN yum update -y && yum install -y curl wget zlib-devel boost-devel time lzma
RUN yum groupinstall -y 'Development Tools'

#LMAT source code
WORKDIR /LMAT
RUN curl -LO https://sourceforge.net/projects/lmat/files/LMAT-1.2.4.tgz && tar -zxf LMAT-1.2.4.tgz

#modified get_db to work
WORKDIR /LMAT/LMAT-1.2.4/bin
RUN rm get_db.sh
COPY get_db.sh /LMAT/LMAT-1.2.4/bin
# added #include <getopt.h> to src/frequencey_counter.cpp
WORKDIR /LMAT/LMAT-1.2.4/src
RUN rm frequency_counter.cpp
COPY frequency_counter.cpp /LMAT/LMAT-1.2.4/src
WORKDIR /LMAT/LMAT-1.2.4/bin
ARG db_name
RUN bash ./get_db.sh --dtype=inputs --name=$db_name --outdir=/LMAT/LMAT-1.2.4/
ENV LMAT_DIR='/LMAT/LMAT-1.2.4/runtime_inputs' 

#Marker libaries
WORKDIR /LMAT/marker_lib
ARG marker_db_arg
ENV marker_db=$marker_db_arg
WORKDIR /LMAT/LMAT-1.2.4/bin
RUN bash ./get_db.sh --dtype=db --name=$marker_db
RUN mv $marker_db_arg /LMAT/marker_lib/$marker_db_arg

#Build source code
WORKDIR /LMAT/LMAT-1.2.4/third-party
RUN make all
WORKDIR /LMAT/LMAT-1.2.4
RUN make

#Creating examples to test with
WORKDIR /LMAT/LMAT-1.2.4/example
RUN tar zxvf example.tgz
WORKDIR /LMAT/LMAT-1.2.4/bin




