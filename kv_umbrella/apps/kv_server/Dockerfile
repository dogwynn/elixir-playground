from ubuntu:19.04

RUN apt-get update
RUN apt-get install -y tcpreplay net-tools

RUN mkdir /pcaps

WORKDIR /pcaps

COPY llmnr*.pcap ./

