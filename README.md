# Vote_app_cluster
This repository is based on the [example-voting-app](https://github.com/dockersamples/example-voting-app) project, with the following additional features:

- PostgreSQL database cluster
- Redis database cluster
- Monitoring and logging
- Backup solution

## PostgreSQL Cluster

For the HA PostgreSQL cluster, we used [Patroni](https://github.com/patroni/patroni).

### What is Patroni?

Patroni is a template for high availability (HA) PostgreSQL solutions using Python. It is designed to be accessible and versatile, supporting a variety of distributed configuration stores like ZooKeeper, etcd, Consul, or Kubernetes.
