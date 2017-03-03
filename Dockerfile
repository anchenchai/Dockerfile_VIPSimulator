FROM ubuntu:latest
MAINTAINER Anchen CHAI (chai@creatis.insa-lyon.fr)

RUN apt-get update && apt-get install -y \
    git gcc g++ cmake python3 default-jdk subversion \
    libboost-dev libboost-context-dev \
    libboost-test-dev doxygen \
    r-base r-cran-xml r-cran-plyr r-cran-reshape2


RUN git clone git://scm.gforge.inria.fr/simgrid/simgrid.git
WORKDIR /simgrid 
RUN mkdir build 
WORKDIR build
RUN cmake -Denable_java=ON .. && make \
    && echo "export SIMGRID_PATH=/simgrid/build" >> ~/.bashrc
ENV SIMGRID_PATH=/simgrid/build

WORKDIR /
RUN git clone https://github.com/frs69wq/VIPSimulator.git
WORKDIR /VIPSimulator 
RUN mkdir bin && echo "export VIPSIM=/VIPSimulator" >> ~/.bashrc \
    && javac -encoding UTF-8 -cp "${SIMGRID_PATH}/simgrid.jar" \
    src/*.java -d bin

ENV VIPSIM=/VIPSimulator

WORKDIR /
RUN git clone https://github.com/frs69wq/log2sim.git
RUN	echo "export LOG2SIM_HOME=/log2sim" >> ~/.bashrc
ENV LOG2SIM_HOME=/log2sim



