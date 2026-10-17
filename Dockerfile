# syntax=docker/dockerfile:1

FROM alpine:3.17.10

LABEL org.opencontainers.image.title="OpenVPN client for WD My Cloud EX4100" \
      org.opencontainers.image.description="Minimal ARMv7 OpenVPN gateway for WD My Cloud EX4100" \
      org.opencontainers.image.source="https://github.com/dart998/openvpn-ex4100"

RUN apk add --no-cache \
      ca-certificates \
      iproute2 \
      iptables \
      openvpn \
      tini \
      tzdata \
    && update-ca-certificates \
    && mkdir -p /config \
    && /sbin/iptables --version \
    && /sbin/iptables-legacy --version \
    && openvpn --version | head -n 1 \
    && grep -Fx '3.17.10' /etc/alpine-release

COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod 0755 /usr/local/bin/entrypoint.sh

ENV TZ=Europe/Madrid \
    OVPN_CONFIG=/config/client.ovpn \
    OVPN_AUTH=/config/auth.txt \
    LAN_SUBNET=192.168.178.0/24 \
    KILLSWITCH=on

ENTRYPOINT ["/sbin/tini","--","/usr/local/bin/entrypoint.sh"]
