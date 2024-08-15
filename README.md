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

### Architecture

The architecture sets up a high-availability PostgreSQL cluster using Patroni, with an etcd backend for distributed consensus and HAProxy for load balancing across three Patroni-managed PostgreSQL instances. All components are interconnected within a backend Docker network. 

- **etcd cluster**: Consists of three nodes (etcd1, etcd2, etcd3) to ensure synchronization among the Patroni nodes.
- **Patroni nodes**: Three instances (patroni1, patroni2, patroni3) manage the PostgreSQL cluster.
- **HAProxy**: Handles client traffic distribution across the Patroni-managed PostgreSQL instances, labeled as `db` in the architecture.
