FROM ubuntu:latest

RUN apt-get update --fix-missing

RUN apt-get install -y wget \
                    -y python3 \
                    python3-setuptools \
                    python3-pip && \
     ln -s /usr/bin/python3.6 /usr/bin/python

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y mono-devel \
                                     gettext-base
                                
RUN pip3 install robotframework