FROM debian:jessie

ENV GF_SERVER_HTTP_PORT=8080
ENV GF_PATHS_DATA=/var/lib/grafana
ENV GF_PATHS_LOGS=/var/log/grafana
ENV GF_PATHS_PLUGINS=/var/lib/grafana/plugins
ENV GF_PATHS_VAR_RUN=/var/run/grafana

RUN mkdir -p $GF_PATHS_DATA \
	&& mkdir -p $GF_PATHS_LOGS \
	&& mkdir -p $GF_PATHS_PLUGINS \
	&& mkdir -p $GF_PATHS_VAR_RUN \
	&& apt-get update \
	&& apt-get install -y -f \
	libfontconfig \
	wget \
	&& apt-get autoremove -y \
	&& apt-get autoclean -y \
	&& wget --content-disposition https://packagecloud.io/grafana/stable/packages/debian/jessie/grafana_4.5.2_amd64.deb/download.deb -O grafana.deb \
	&& dpkg -i grafana.deb \
	&& rm grafana.deb \
	&& usermod -u 888 grafana && groupmod -g 888 grafana \
	&& chown -R grafana:grafana /etc/grafana \
	&& chown -R grafana:grafana $GF_PATHS_DATA \
	&& chown -R grafana:grafana $GF_PATHS_LOGS \
	&& chown -R grafana:grafana $GF_PATHS_PLUGINS \
	&& chown -R grafana:grafana $GF_PATHS_VAR_RUN \
	&& chown grafana:grafana /etc/grafana/grafana.ini \
	&& chmod 777 /etc/grafana/grafana.ini \
	&& chmod -R 777 /etc/grafana \
	&& chmod -R 777 $GF_PATHS_DATA \
	&& chmod -R 777 $GF_PATHS_LOGS \
	&& chmod -R 777 $GF_PATHS_PLUGINS \
	&& chmod -R 777 $GF_PATHS_VAR_RUN

EXPOSE 8080

USER grafana

ENTRYPOINT ["/usr/sbin/grafana-server", \
			"--homepath=/usr/share/grafana", \
			"--pidfile=/var/run/grafana/grafana-server.pid", \
			"--config=/etc/grafana/grafana.ini", \
			"cfg:default.paths.data=\"$GF_PATHS_DATA\"", \
			"cfg:default.paths.logs=\"$GF_PATHS_LOGS\"", \
			"cfg:default.paths.plugins=\"$GF_PATHS_PLUGINS\"" ]