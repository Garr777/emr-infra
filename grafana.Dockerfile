FROM grafana/grafana:latest
# bake provisioning (datasources + dashboards) into the image so it survives
# container recreation, re-pulls and host reboots
COPY grafana/provisioning /etc/grafana/provisioning
