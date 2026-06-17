FROM prom/prometheus:latest
# bake the scrape config into the image so it survives container recreation
COPY prometheus.yml /etc/prometheus/prometheus.yml
