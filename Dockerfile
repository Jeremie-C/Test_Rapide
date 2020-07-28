FROM alpine:latest

RUN apk -U upgrade
RUN apk --no-cache add \
  dnsmasq \
  supervisor \
  tzdata

RUN cp /usr/share/zoneinfo/Europe/Paris /etc/localtime && \
  echo "Europe/Paris" > /etc/timezone

RUN apk del tzdata \
  && rm -rf /var/cache/apk/*

RUN wget -qO- https://github.com/Jeremie-C/my-docker-gen/releases/download/0.7.5/docker-gen-alpine-linux-amd64-0.7.5.tar.gz | tar xvz -C /usr/local/bin

RUN mkdir -p /etc/dnsmasq.d && \
	rm -f /etc/dnsmasq.conf && \
  rm -f /etc/supervisord.conf

COPY fichiers/dnsmasq.conf /etc/dnsmasq.conf
COPY fichiers/dnsmasq.tmpl /etc/dnsmasq.d/dockergen.tmpl
COPY fichiers/supervisord.conf /etc/supervisord.conf

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