# mias
monitoring/metrics in a stack

## Prerequisites
* A pre-existing docker swarm already setup and configured is necessary for orchestration of the stack.
* A domain or subdomain with the A record pointed to the IP address of the gateway node for automatic issuance of a Let's Encrypt SSL certificate.

## Introduction

`mias` is a simple passive push-based monitoring/metrics bundle in the form of a docker swarm stack. It can be used to collect system resource metrics like bandwidth, cpu use, etc from remote hosts participating in a docker swarm and then push them back to a centralized location. Alerting then can be enabled and configured within the dashboard to act upon those metrics.

Node-exporter and vmagent are deployed to all docker workers as "agents" via a global service. Preprovisioned instances of Grafana and victoria-metrics-prod are deployed on the node of your choosing via labels to provide an overview and general dashboard.

## Why "push" and not "pull"?
Simply put, a push-based strategy for delivering metrics was a constraint of this project. If you have recently discovered this project and are looking to use a more common pull-based strategy; we suggest searching for an alternative stack rather than trying to adapt this project to fit your needs.

## Service containers

The mias stack leverages single node, non-replicated, containers of the following services from the latest images below:

* [monitoring_grafana](https://hub.docker.com/r/grafana/grafana-oss/) "grafana-oss" courtesy of Grafana
* [node-exporter](https://hub.docker.com/r/prom/node-exporter) courtesy of Prometheus
* [vmagent](https://hub.docker.com/r/victoriametrics/vmagent) courtesy of VictoriaMetrics
* [vmgateway](https://hub.docker.com/r/victoriametrics/victoria-metrics/) "victoria-metrics-prod" courtesy of VictoriaMetrics
* [caddy](https://hub.docker.com/_/caddy) "Caddy" courtesy of the Caddy Docker Maintainers

## Exposed ports
No additional external ports are opened beyond ports `443` and `80` of the Grafana container hosting the vmgateway service.

# Installation

Clone or download this repository.  Review `./docker-compose.yml` and make any changes that may be required for your production environment.

### Label
Specify a single docker worker node to act as the centralized location for the Grafana dashboard.

* Obtain the node ID of a worker.  From the manager node of the swarm type:
```
docker node ls
```
* Add the `monitoringrole=gateway` label to that node:
```
docker node update --label-add=monitoringrole=gateway <nodeid>
```

### Secrets
Set a unique Grafana dashboard password in the following file:
```
./secrets/gf_admin_password.txt
```
### Deploy

Deploy the stack to all docker worker nodes.  From the manager node type:
```
MIAS_DOMAIN="your-specified-domain.com" docker stack deploy -c docker-compose.yml monitoring
```

## Post installation
Visit port `https://your-specified-domain.com` use the username `admin` with the previously specified password.

## Tagging images
You may desire to tag the images within `docker-compose.yml` instead of relying upon the latest images for a more consistent deployment experience in production.

## Troubleshooting
To review logs, from the manager node of the swarm, type:
```
docker service logs monitoring_grafana -f
docker service logs monitoring_node-exporter -f
docker service logs monitoring_vmagent -f
docker service logs monitoring_vmgateway -f
docker service logs monitoring_caddy -f
```

## Credits
The included Grafana dashboard was modified from the popular [Node Exporter Server Metrics](https://grafana.com/grafana/dashboards/405/) by Knut Ytterhaug