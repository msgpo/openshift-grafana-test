#!/bin/bash

export GF_SERVER_HTTP_PORT=8080

export GF_PATHS_DATA=${GF_PATHS_DATA:=/var/lib/grafana}
export GF_PATHS_LOGS=${GF_PATHS_LOGS:=/var/log/grafana}
export GF_PATHS_PLUGINS=${GF_PATHS_PLUGINS:=/var/lib/grafana/plugins}

# Create Grafana working directories
if [ ! -d $GF_PATHS_DATA ]; then
	mkdir -p $GF_PATHS_DATA
fi

if [ ! -d $GF_PATHS_LOGS ]; then
	mkdir -p $GF_PATHS_LOGS
fi

if [ ! -d $GF_PATHS_PLUGINS ]; then
	mkdir -p $GF_PATHS_PLUGINS
fi

if [ ! -d /var/run/grafana ]; then
	mkdir -p /var/run/grafana
fi

chown -R grafana:grafana /etc/grafana
chown -R grafana:grafana $GF_PATHS_DATA
chown -R grafana:grafana $GF_PATHS_LOGS
chown -R grafana:grafana $GF_PATHS_PLUGINS
chown -R grafana:grafana /var/run/grafana

exec sudo -E -u grafana /usr/sbin/grafana-server \
		--homepath=/usr/share/grafana \
		--pidfile=/var/run/grafana/grafana-server.pid \
		--config=/etc/grafana/grafana.ini \
		cfg:default.paths.data="$GF_PATHS_DATA" \
		cfg:default.paths.logs="$GF_PATHS_LOGS" \
		cfg:default.paths.plugins="$GF_PATHS_PLUGINS"