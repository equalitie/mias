#!/bin/bash

cmd1="/project/node_exporter --web.listen-address=0.0.0.0:9100 --path.procfs=/host/proc --path.rootfs=/rootfs --path.sysfs=/host/sys --collector.filesystem.mount-points-exclude=^/(sys|proc|dev|host|etc)($$|/)"
cmd2="/project/vmagent-prod -promscrape.config=./prometheus.yml -remoteWrite.tmpDataPath=/opt/vmagent/storage -remoteWrite.url=http://vmgateway:8428/api/v1/write"

$cmd1 &
# Start the second process

$cmd2 &
# Wait for any process to exit
wait -n

# Exit with status of process that exited first
exit $?
