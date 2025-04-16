# certimate-docker

Certimate docker image built in docker:cli base image


## Purpose
With this image we can execute docker commands in deployment pipelines.   
By mounting `/var/run/docker.sock` of host machine to container, we can execute docker commands in container to interact with host machine's docker daemon.   
for example, we can execute `docker exec -it nginx nginx -s reload` or `docker restart nginx` in pipeline to reload nginx after ssl certificate is renewed.

## build
```shell
git clone https://github.com/imaxwen/certimate-with-docker-cli.git

cd certimate-with-docker-cli

# ./build.sh ${version} ${plateform}

# plateform options: 
# - linux_amd64
# - linux_arm64
# - linux_armv7
# - darwin_amd64
# - darwin_arm64
# - windows_amd64
# - windows_arm64

# change the registry url in build.sh to your registry

./build.sh 0.3.8 linux_amd64

```

## docker-compose.yml
```yaml
# docker-compose example

services:
  nginx:
    image: nginx:stable-alpine
    container_name: nginx
    restart: always
    volumes: 
      - /etc/localtime:/etc/localtime:ro
      - /etc/timezone:/etc/timezone:ro
      - ./nginx/nginx.conf:/etc/nginx/nginx.conf
      - ./nginx/conf.d:/etc/nginx/conf.d
      # shared certs volume
      - ./certs:/etc/nginx/certs
    ports:
      - "80:80"
      - "443:443"

  certimate:
    image: registry.cn-shanghai.aliyuncs.com/maxwen/certimate-docker:latest
    container_name: certimate
    restart: unless-stopped
    volumes:
      - /etc/localtime:/etc/localtime:ro
      - /etc/timezone:/etc/timezone:ro
      - /var/run/docker.sock:/var/run/docker.sock:ro  # connect to host docker daemon
      - ./volumes/certimate:/app/pb_data
      # shared certs volume
      - ./certs:/etc/certs
    ports:
      - 8090:8090

```


