FROM prom/node-exporter:v1.3.1
USER root
WORKDIR /project
RUN cp /bin/node_exporter /project/node_exporter
COPY . .

FROM victoriametrics/vmagent:v1.72.0
WORKDIR /project
COPY --from=0 /project/node_exporter .
RUN cp /vmagent-prod /project/vmagent-prod
COPY . .
ENTRYPOINT /bin/sh /project/wrapper.sh
