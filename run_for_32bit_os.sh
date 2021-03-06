#!/bin/bash

# db-data volume
docker volume create --name redminedocker_db-data

# db
docker container run \
  -d \
  -e 'DATADIR=/var/lib/mysql' \
  -e 'MYSQL_ROOT_PASSWORD=redmine' \
  -e 'MYSQL_DATABASE=redmine' \
  -e 'MYSQL_USER=redmine' \
  -e 'MYSQL_PASSWORD=redmine' \
  -e 'TZ=Asia/Tokyo' \
  --name redminedocker_db_1 \
  -p 50104:3306 \
  --restart unless-stopped \
  -v /etc/localtime:/etc/localtime:ro \
  -v redminedocker_db-data:/var/lib/mysql \
  learnin/redmine-db

# app-data volume
docker volume create --name redminedocker_app-data

# app
docker container run \
  -d \
  -e 'REDMINE_DB_MYSQL=db' \
  -e 'MYSQL_ENV_MYSQL_USER=redmine' \
  -e 'MYSQL_ENV_MYSQL_PASSWORD=redmine' \
  -e 'MYSQL_ENV_MYSQL_DATABASE=redmine' \
  -e 'REDMINE_DB_ENCODING=utf8mb4' \
  -e 'TZ=Asia/Tokyo' \
  -e "http_proxy=$http_proxy" \
  -e "https_proxy=$https_proxy" \
  --link redminedocker_db_1:db \
  --name redminedocker_app_1 \
  -p 50004:3000 \
  --restart unless-stopped \
  -v /etc/localtime:/etc/localtime:ro \
  -v redminedocker_app-data:/usr/src/redmine/files \
  redmine:3.3.2-passenger
