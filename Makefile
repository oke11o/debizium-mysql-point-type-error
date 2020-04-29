#!make

######## DOCKER #########
docker-up:
	docker-compose up --build -d

docker-down:
	docker-compose down
######## end DOCKER #########

######## MIGRATIONS #########
migration-up:
	goose -dir migrations mysql "myuser:mypass@tcp(localhost:3306)/mydb?parseTime=true&multiStatements=true" up
######## end MIGRATIONS #########


######## KAFKA BROKER #########
kafka-topic-list:
	docker-compose exec kafka-broker kafka-topics.sh --list --zookeeper zookeeper:2181/local

kafka-topic-create-catalog-public-favourites:
	docker-compose exec kafka-broker kafka-topics.sh --create --topic catalog.public.orders_address_coords --partitions 3 --replication-factor 1 --zookeeper zookeeper:2181/local

kafka-delete-history-topic:
	docker-compose exec kafka-broker kafka-topics.sh --delete --topic debezium.mysql_history --bootstrap-server localhost:9092

kafka-consumer-topic-debezium:
	docker-compose exec kafka-broker kafka-console-consumer.sh --bootstrap-server=localhost:9092 --topic catalog.public.orders_address_coords --from-beginning
######## end KAFKA BROKER #########

######## KAFKA CONNECT COMMON #########
connect-connectors:
	curl http://localhost:8083/connectors | jq

connect-connector-plugins:
	curl http://localhost:8083/connector-plugins | jq
######## end KAFKA CONNECT COMMON #########


######## DEBEZIUM EXAMPLE #########
create-debezium-source-connector:
	curl -X POST http://localhost:8083/connectors -H "Content-Type: application/json" -d '{ \
				"name": "debezium-source-connector", \
				"config": { \
				  "connector.class": "io.debezium.connector.mysql.MySqlConnector", \
				  "database.hostname": "mysql", \
				  "database.serverTimezone": "Europe/Moscow", \
				  "database.port": "3306", \
				  "database.user": "root", \
				  "database.password": "mypass", \
				  "database.server.id": "223345", \
				  "database.server.name": "catalog", \
				  "database.whitelist": "mydb", \
				  "database.history.kafka.bootstrap.servers": "kafka-broker:9092", \
				  "database.history.kafka.topic": "debezium.mysql_history", \
				  "include.schema.changes": "true", \
				  "transforms": "route", \
				  "transforms.route.type": "org.apache.kafka.connect.transforms.RegexRouter", \
				  "transforms.route.regex": "([^.]+)\\.([^.]+)\\.([^.]+)", \
				  "transforms.route.replacement": "$$1.public.$$3" \
				} \
			  }' | jq

delete-debezium-source-connector:
	curl -X DELETE http://localhost:8083/connectors/debezium-source-connector | jq

status-debezium-source-connector:
	curl -X GET http://localhost:8083/connectors/debezium-source-connector/status | jq

stop-debezium-source-connector:
	curl -X PUT http://localhost:8083/connectors/debezium-source-connector/pause

resume-debezium-source-connector:
	curl -X PUT http://localhost:8083/connectors/debezium-source-connector/resume

config-debezium-source-connector:
	curl -X GET http://localhost:8083/connectors/debezium-source-connector | jq

tasks-debezium-source-connector:
	curl -X GET http://localhost:8083/connectors/debezium-source-connector/tasks | jq
######## end DEBEZIUM EXAMPLE #########

