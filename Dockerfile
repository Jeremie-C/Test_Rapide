FROM alpine:latest

RUN apk -U upgrade
RUN apk --no-cache add \
  dnsmasq \
  openssl \
  tzdata

RUN cp /usr/share/zoneinfo/Europe/Paris /etc/localtime && \
  echo "Europe/Paris" > /etc/timezone

RUN apk del tzdata

RUN wget -qO- https://github.com/Jeremie-C/my-docker-gen/releases/download/0.7.5/docker-gen-alpine-linux-amd64-0.7.5.tar.gz | tar xvz -C /usr/local/bin

COPY files/dnsmasq.tmpl /etc/dnsmasq.tmpl
COPY files/dnsmasq-reload /usr/local/bin/dnsmasq-reload
RUN chmod a+rwx,o-w /usr/local/bin/dnsmasq-reload

EXPOSE 53/udp

ENV DOCKER_HOST unix:///var/run/docker.sock

ENTRYPOINT ["/usr/local/bin/docker-gen"]
CMD ["-watch", "-only-exposed", "-notify", "dnsmasq-reload -u root", "/etc/dnsmasq.tmpl", "/etc/dnsmasq.conf"]
