#apps: imagenes

cd app-config
docker build -t stebanrodriguez/app-config:0.1.0 .
cd ..
cd app-invoice
docker build -t stebanrodriguez/app-invoice:0.1.0 .
cd ..
cd app-pay
docker build -t stebanrodriguez/app-pay:0.1.0 .
cd ..
cd app-transaction
docker build -t stebanrodriguez/app-transaction:0.1.0 .

#BD: imagenes
cd ..
cd resources/mysql/
docker build -t stebanrodriguez/mysql:0.1.0 .
cd ..
cd postgres
docker build -t stebanrodriguez/postgres:0.1.0 .

#Haproxy:
cd ..
cd ..
cd haproxy
docker build -t stebanrodriguez/loadbalancer:0.1.0 .
cd ..

#----------------------------------------------------------------------------------------
#					RUN containers:

#consul:
docker run -d -p 8500:8500 -p 8600:8600/udp --network distribuidos --name consul consul:1.15 agent -server -bootstrap-expect 1 -ui -data-dir /tmp -client=0.0.0.0

#Kafka:
docker run -p 2181:2181 -d -p 9092:9092 --name servicekafka --network distribuidos -e ADVERTISED_HOST=servicekafka -e NUM_PARTITIONS=3 johnnypark/kafka-zookeeper:2.6.0

#Postgres:
docker run -p 5434:5432  --name postgres --network distribuidos -e POSTGRES_PASSWORD=postgres -e  POSTGRES_DB=db_invoice -d postgres:12-alpine

#mongo
docker run -p 27017:27017 --network distribuidos --name mongodb -d mongo

#mysql
docker run -p 3306:3306 --name mysql --network distribuidos -e MYSQL_ROOT_PASSWORD=mysql -e MYSQL_DATABASE=db_operation -d stebanrodriguez/mysql:0.1.0

#app-config up
docker run -d -p 8888:8888 --network distribuidos --name app-config stebanrodriguez/app-config:0.1.0

#app-invoice up
docker run -d -p 8006:8006 --network distribuidos --name app-invoice stebanrodriguez/app-invoice:0.1.0

#app-pay up
docker run -d -p 8010:8010 --network distribuidos --name app-pay stebanrodriguez/app-pay:0.1.0

#app-transaction up
docker run -d -p 8082:8082 --network distribuidos --name app-transaction stebanrodriguez/app-transaction:0.1.0

#app-loadbalancer up
docker run -d -p 9000:80 -p 1936:1936 --network distribuidos --name loadbalancer stebanrodriguez/loadbalancer:0.1.0

#lista de contenedores:
docker ps -a
