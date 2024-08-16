# Vote_App_Cluster

This repository is based on the [example-voting-app](https://github.com/dockersamples/example-voting-app) project, with the following additional features:

- PostgreSQL database cluster
- Redis database cluster
- Monitoring and logging
- Backup solution
```
docker stack deploy -c  app/app.yml vote
```
## PostgreSQL Cluster

For the HA PostgreSQL cluster, we used [Patroni](https://github.com/patroni/patroni).


### What is Patroni?

Patroni is a template for high availability (HA) PostgreSQL solutions using Python. It is designed to be accessible and versatile, supporting a variety of distributed configuration stores like ZooKeeper, etcd, Consul, or Kubernetes.

### Architecture

The architecture sets up a high-availability PostgreSQL cluster using Patroni, with an etcd backend for distributed consensus and HAProxy for load balancing across three Patroni-managed PostgreSQL instances. All components are interconnected within a backend Docker network. 

- **etcd cluster**: Consists of three nodes (etcd1, etcd2, etcd3) to ensure synchronization among the Patroni nodes.
- **Patroni nodes**: Three instances (patroni1, patroni2, patroni3) manage the PostgreSQL cluster.
- **HAProxy**: Handles client traffic distribution across the Patroni-managed PostgreSQL instances, labeled as `db` in the architecture.
```
docker stack deploy -c  postgres/postgres.yml vote
```
## Redis Cluster

In this project, we've implemented a Redis master-slave replication setup, where Redis operates with a single master and two slave nodes to provide read redundancy and load distribution. While the ideal setup for high availability and fault tolerance would involve a Redis Sentinel or Cluster configuration with multi-master support, our choice of this architecture is driven by the constraints of the prebuilt application in use, which does not handle multi-master Redis clusters. We acknowledge that a more robust solution would involve Redis Cluster for true high availability and fault tolerance, but the current configuration aligns with the capabilities and requirements of the existing application.


```
docker stack deploy -c  redis/redis.yml vote
```

### What Was the Best Solution?

For a more robust and fault-tolerant Redis setup, the best practice is to use Redis Cluster. Redis Cluster allows for data sharding across multiple master nodes, each handling a portion of the data, and provides automatic failover and rebalancing. In the event of a master node failure, Redis Cluster promotes one of the replica nodes to master, ensuring minimal disruption. This architecture offers high availability and horizontal scalability, handling both read and write operations efficiently across the cluster, making it a more resilient and scalable solution compared to a simple master-slave configuration.

## Monitoring

The monitoring solution employs Prometheus for collecting metrics, Grafana for visualizing those metrics, Redis Exporter for monitoring Redis, and PostgreSQL Exporter for tracking PostgreSQL performance. It sets up specific networks for service isolation and uses volumes for persistent data storage.

```
docker stack deploy -c  monitoring/monitoring.yml vote
```

## Logging

The logging solution deploys a stack with Elasticsearch for data storage, Kibana for visualization, and Logstash for log processing. Elasticsearch and Logstash are connected to multiple networks for handling logs, while Kibana depends on Elasticsearch and Logstash for data display. The Logstash configuration is managed externally, and Kibana logs are sent via GELF.

```
docker stack deploy -c  elk/elk.yml vote
```

## Backup

The backup solution schedules hourly backups using a cron job in an Alpine container. This container mounts a backup script and necessary volumes, executes the script every hour to back up PostgreSQL and Redis data, and stores the backups in a specified volume. The container is connected to both frontend and backend networks and uses the Docker socket for interacting with other containers.

```
docker stack deploy -c  backup/backup.yml vote
```

## considerations
- the provided manifests are considered for a test environment, so credential management are not provided. For the production environment, all databases must have credentials in a secured manner.
