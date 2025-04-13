# certimate-docker

Certimate docker image built in docker:cli base image


## Purpose
With this image we can execute docker commands in deployment pipelines.   
By mounting `/var/run/docker.sock` of host machine to container, we can execute docker commands in container to interact with host machine's docker daemon.   
for example, we can execute `docker exec -it nginx nginx -s reload` or `docker restart nginx` in pipeline to reload nginx after ssl certificate is renewed.


## docker-compose.yml
```yaml
services:
  nginx:
    image: nginx:latest
    # ...your nginx container configurations

  certimate:
    image: maxwen/certimate-docker:latest
    container_name: certimate-server
    ports:
      - 8090:8090
    volumes:
      - /etc/localtime:/etc/localtime:ro
      - /etc/timezone:/etc/timezone:ro
      - /var/run/docker.sock:/var/run/docker.sock:ro
      - ./volumes:/app/pb_data
    restart: unless-stopped

```


