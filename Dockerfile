FROM openjdk:13.0.1-slim-buster
MAINTAINER Neil Best <nbest937@gmail.com>


ENV SCALA_VERSION 2.12
ENV COURSIER_VERSION v2.0.0-RC5-3
ENV COURSIER_URL https://github.com/coursier/coursier/releases/download/${COURSIER_VERSION}/coursier
ENV AMM_VERSION 1.8.1
# ENV AMM_FILE $SCALA_VERSION-$AMM_VERSION
# ENV AMM_URL https://github.com/lihaoyi/Ammonite/releases/download/$AMM_VERSION/$AMM_FILE

WORKDIR /usr/local/bin

RUN curl -Lo coursier $COURSIER_URL \
 && chmod +x coursier \
 && ./coursier --help

# RUN (echo '#!/usr/bin/env sh' && curl -L "$AMM_URL") > /usr/local/bin/amm \
# && chmod +x "/usr/local/bin/amm"

WORKDIR /

RUN coursier fetch \
 org.apache.spark:spark-sql:2.4.0
 
RUN coursier fetch \
 -r jitpack
 com.github.nbest937:ammonite-spark:fc59944f
 
RUN coursier bootstrap \
 com.lihaoyi:ammonite_${SCALA_VERSION}:${AMM_VERSION} \
 -M ammonite.Main \
 -o amm

# CMD amm

RUN amm -c ""

CMD amm
