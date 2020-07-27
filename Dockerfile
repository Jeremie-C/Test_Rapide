FROM alpine:latest

RUN apk -U upgrade
RUN apk --no-cache add \
  dnsmasq \
  openssl \
  rc-status \
  tzdata

RUN cp /usr/share/zoneinfo/Europe/Paris /etc/localtime && \
  echo "Europe/Paris" > /etc/timezone

RUN apk del tzdata

RUN rc-update add dnsmasq default

RUN wget -qO- https://github.com/Jeremie-C/my-docker-gen/releases/download/0.7.5/docker-gen-alpine-linux-amd64-0.7.5.tar.gz | tar xvz -C /usr/local/bin

USER root
COPY docker-files/. /

EXPOSE 53/udp

ENV DOCKER_HOST unix:///var/run/docker.sock

ENTRYPOINT ["/usr/local/bin/docker-gen"]
CMD ["-watch", "-only-exposed", "-notify", "rc-service dnsmasq restart", "/etc/dnsmasq.tmpl", "/etc/dnsmasq.conf"]
