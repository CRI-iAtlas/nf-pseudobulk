FROM python:3.11-slim as build

RUN apt-get update 
RUN apt install curl -y 

WORKDIR /tmp

COPY requirements.txt /tmp

RUN pip3 install --no-cache-dir --upgrade \
    -r /tmp/requirements.txt
