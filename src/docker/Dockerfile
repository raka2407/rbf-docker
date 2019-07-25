FROM ubuntu:latest

RUN apt-get update --fix-missing

RUN apt-get install -y curl \
                    -y wget \
                    -y python3 \
                    python3-setuptools \
                    python3-pip && \
     ln -s /usr/bin/python3.6 /usr/bin/python

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y mono-devel \
                                     gettext-base
                                
RUN pip3 install robotframework

RUN apt-get install -y unzip xvfb libxi6 libgconf-2-4

RUN apt-get install -y default-jdk 

RUN curl -sS -o - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add
RUN echo "deb [arch=amd64]  http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list
RUN apt-get -y install google-chrome-stable

RUN wget https://chromedriver.storage.googleapis.com/75.0.3770.140/chromedriver_linux64.zip
RUN unzip chromedriver_linux64.zip
RUN mv chromedriver /usr/bin/chromedriver
RUN chown root:root /usr/bin/chromedriver
RUN chmod +x /usr/bin/chromedriver

