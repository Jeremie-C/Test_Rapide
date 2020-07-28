FROM alpine:latest

RUN apk -U upgrade
RUN apk --no-cache add \
  dnsmasq \
  supervisor \
  tzdata \
  && rm -rf /var/cache/apk/*

RUN cp /usr/share/zoneinfo/Europe/Paris /etc/localtime && \
  echo "Europe/Paris" > /etc/timezone

RUN apk del tzdata

RUN wget -qO- https://github.com/Jeremie-C/my-docker-gen/releases/download/0.7.5/docker-gen-alpine-linux-amd64-0.7.5.tar.gz | tar xvz -C /usr/local/bin

RUN mkdir -p /etc/dnsmasq.d && \
	echo -e '\nconf-dir=/etc/dnsmasq.d,.tmpl' >> /etc/dnsmasq.conf

COPY fichiers/dnsmasq.tmpl /etc/dnsmasq.d/dockergen.tmpl
COPY fichiers/supervisord.conf /etc/supervisor.d/docker-gen.ini

COPY docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod a+rwx,o-w /docker-entrypoint.sh

ENV DNS_DOMAIN 'docker.local'
ENV DNS_IP '192.168.1.1'
ENV LOG_QUERIES false
ENV DOCKER_HOST unix:///var/run/docker.sock

EXPOSE 53/udp

VOLUME /etc/dnsmasq.d

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["supervisord", "-n"]