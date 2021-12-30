FROM ubuntu:18.04

COPY sources.list /etc/apt/
RUN apt-get update
# RUN DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends apt-utils
RUN apt-get upgrade -y


RUN apt-get install -y python3
RUN apt-get install -y vim
RUN apt-get install -y curl
RUN apt-get install -y iputils-ping
RUN apt-get install -y net-tools


RUN apt-get install -y python3-pip
RUN pip3 install requests

COPY curl/apiserver-kubelet-client.crt /home
COPY curl/apiserver-kubelet-client.key /home
COPY curl/ca.crt /home
COPY curl/curl.sh /home