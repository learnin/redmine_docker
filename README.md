# redmine-docker

## Getting started

### When using Docker Compose
```shell
export http_proxy=http://your_proxy_host:your_proxy_port/
export https_proxy=http://your_proxy_host:your_proxy_port/
export HTTP_PROXY=$http_proxy
export HTTPS_PROXY=$https_proxy
export no_proxy=`docker-machine ip default`
export NO_PROXY=$no_proxy

docker-compose up -d
```
### When not using Docker Compose(e.g. Windows 32bit)
```shell
export http_proxy=http://your_proxy_host:your_proxy_port/
export https_proxy=http://your_proxy_host:your_proxy_port/
export HTTP_PROXY=$http_proxy
export HTTPS_PROXY=$https_proxy
export no_proxy=`docker-machine ip default`
export NO_PROXY=$no_proxy

docker-machine scp run_for_32bit_os.sh default:/tmp/redmine_run_for_32bit_os.sh
docker-machine ssh default "export http_proxy=$http_proxy; export https_proxy=$https_proxy; sh /tmp/redmine_run_for_32bit_os.sh; rm -f /tmp/redmine_run_for_32bit_os.sh"
```

# For developers

## How to build and run

### When using Docker Compose
```shell
export http_proxy=http://your_proxy_host:your_proxy_port/
export https_proxy=http://your_proxy_host:your_proxy_port/
export HTTP_PROXY=$http_proxy
export HTTPS_PROXY=$https_proxy
export no_proxy=`docker-machine ip default`
export NO_PROXY=$no_proxy

docker-compose -f docker-compose-build.yml build
docker-compose -f docker-compose-build.yml up -d
```
### When not using Docker Compose(e.g. Windows 32bit)
```shell
export http_proxy=http://your_proxy_host:your_proxy_port/
export https_proxy=http://your_proxy_host:your_proxy_port/
export HTTP_PROXY=$http_proxy
export HTTPS_PROXY=$https_proxy
export no_proxy=`docker-machine ip default`
export NO_PROXY=$no_proxy

docker image build -t redminedocker_db db

docker volume create --name redminedocker_db-data
docker volume create --name redminedocker_app-data

docker-machine ssh default "docker container run \
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
  redminedocker_db"

docker-machine ssh default "export http_proxy=$http_proxy; export https_proxy=$https_proxy; docker container run \
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
  redmine:3.3.2-passenger"
```
