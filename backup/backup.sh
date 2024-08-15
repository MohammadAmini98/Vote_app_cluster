#!/bin/bash

# Perform a backup through HAProxy, using the `db` service to connect to the current leader
docker exec db pg_dumpall -h localhost -p 5432 -U postgres > /backup/postgres_backup_$(date +\%Y\%m\%d\%H\%M\%S).sql

# Create a backup of Redis
docker exec redis-master redis-cli save
docker cp redis-master:/data/dump.rdb /backup/redis_backup_$(date +\%Y\%m\%d\%H\%M\%S).rdb

