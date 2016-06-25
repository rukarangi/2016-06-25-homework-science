FROM rocker/hadleyverse
MAINTAINER finlay@dragonfly.co.nz

RUN apt-get update && apt-get install pandoc -y

RUN ln -s /usr/local/bin/pandoc /opt/pandoc/pandoc
