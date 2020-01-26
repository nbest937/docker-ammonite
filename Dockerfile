FROM openjdk:13.0.1-slim-buster
MAINTAINER Neil Best <nbest937@gmail.com>

# ENV AMM_FILE $SCALA_VERSION-$AMM_VERSION
# ENV AMM_URL https://github.com/lihaoyi/Ammonite/releases/download/$AMM_VERSION/$AMM_FILE

RUN apt-get update && apt-get -y install curl

WORKDIR /usr/local/bin

ENV COURSIER_VERSION v2.0.0-RC5-3
ENV COURSIER_URL https://github.com/coursier/coursier/releases/download/${COURSIER_VERSION}/coursier

RUN curl -Lo coursier $COURSIER_URL \
 && chmod +x coursier \
 && ./coursier --help

# RUN (echo '#!/usr/bin/env sh' && curl -L "$AMM_URL") > /usr/local/bin/amm \
# && chmod +x "/usr/local/bin/amm"

WORKDIR /

RUN coursier fetch \
 org.apache.spark::spark-sql:2.4.0

# RUN coursier fetch \
#  -r jitpack \
#  com.github.nbest937:ammonite-spark:fc59944f

RUN coursier fetch \
 -r sonatype:snapshots \
 sh.almond:ammonite-spark_2.12:0.8.0+16-fc59944f-SNAPSHOT

ENV SCALA_VERSION 2.12.10
ENV AMM_VERSION 2.0.1

RUN coursier bootstrap \
 com.lihaoyi:ammonite_${SCALA_VERSION}:${AMM_VERSION} \
 -M ammonite.Main \
 -o amm

# CMD amm

RUN ./amm -c ""

CMD ./amm
