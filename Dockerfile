FROM ubuntu:latest
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update
RUN apt-get install --yes cadaver jq
ADD /check /opt/resource/check
ADD /out /opt/resource/out
ADD /in /opt/resource/in
RUN chmod +x /opt/resource/*
