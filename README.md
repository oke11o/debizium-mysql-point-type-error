# Debezium mysql source connector. Point type error

Reproducing an error

```shell script
Unexpected value for JDBC type 1111 and column point POINT NOT NULL DEFAULT VALUE
```

1. `clone project`
1. `make docker-up`
1. `make create-debezium-source-connector`
1. wait few seconds
1. `make status-debezium-source-connector`

There are same command to help work with kafka connect. Follow `Makefile`