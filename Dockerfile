FROM lsiobase/alpine:3.11

ENV WG_ROUTER_IP=192.168.77.254/32
ENV WG_PRIVKEY=

RUN apk add --no-cache wireguard-tools

COPY root/ /

EXPOSE 51820/UDP
