# syntax = docker/dockerfile:1.0-experimental
FROM wurstmeister/kafka:2.12-2.3.0 as kafka-base

WORKDIR /opt/kafka

RUN wget https://repo1.maven.org/maven2/io/debezium/debezium-connector-mysql/1.1.0.Final/debezium-connector-mysql-1.1.0.Final-plugin.tar.gz && \
    tar zxvf debezium-connector-mysql-1.1.0.Final-plugin.tar.gz

RUN mkdir cfg && mkdir plugins
RUN cp debezium-connector-mysql/* libs
RUN mv debezium-connector-mysql plugins

CMD ["bin/connect-distributed.sh", "cfg/connect-distributed.properties"]
