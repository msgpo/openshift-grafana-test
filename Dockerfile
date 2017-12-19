FROM debian:jessie

RUN apt-get update \
	&& apt-get install -y -f \
	curl \
	libfontconfig \
	sudo \
	wget \
	&& apt-get autoremove -y \
	&& apt-get autoclean -y \
	&& wget --content-disposition https://packagecloud.io/grafana/stable/packages/debian/jessie/grafana_4.5.2_amd64.deb/download.deb -O grafana.deb \
	&& dpkg -i grafana.deb \
	&& rm grafana.deb \
	&& usermod -u 888 grafana && groupmod -g 888 grafana

COPY entrypoint.sh /entrypoint.sh

EXPOSE 8080 8888

ENTRYPOINT [ "/bin/bash", "-c", ". /entrypoint.sh" ]