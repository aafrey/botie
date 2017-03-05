!#/bin/bash

docker service rm redis;
docker service create \
    --name redis \
    --dns 8.8.8.8 \
    --env REDIS_PASS="**None**"\
    --mount type=volume,target=/data,source=hubot-brain \
    --network traefik-net \
    redis:alpine
