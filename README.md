docker_redis
============

Dockerfile for building image of redis

Build
============
docker build -t daitak/redis redis/ 

Run container
============

Master
docker run -itd  -p 2222:22 --name redis01 daitak/redis 

Slave
docker run -itd --link redis01:redis_master -p 2022:22 --name redis02 daitak/redis
