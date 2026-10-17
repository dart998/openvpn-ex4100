# syntax=docker/dockerfile:1

FROM debian:bullseye-slim

LABEL org.opencontainers.image.title="OpenVPN client for WD My Cloud EX4100" \
      org.opencontainers.image.description="Minimal ARMv7 OpenVPN gateway for WD My Cloud EX4100" \
      org.opencontainers.image.source="https://github.com/dart998/openvpn-ex4100" \
      org.opencontainers.image.version="1.1.0"

ENV DEBIAN_FRONTEND=noninteractive

RUN set -eux; \
    apt-get update; \
    if ! apt-get install -y --no-install-recommends \
      ca-certificates \
      iproute2 \
      iptables \
      openvpn \
      tini \
      tzdata; then \
      rm -rf /var/lib/apt/lists/*; \
      sleep 5; \
      apt-get update; \
      apt-get install -y --no-install-recommends \
        ca-certificates \
        iproute2 \
        iptables \
        openvpn \
        tini \
        tzdata; \
    fi; \
    update-alternatives --set iptables /usr/sbin/iptables-legacy; \
    update-alternatives --set ip6tables /usr/sbin/ip6tables-legacy; \
    update-ca-certificates; \
    mkdir -p /config; \
    /usr/sbin/iptables --version; \
    /usr/sbin/iptables-legacy --version; \
    openvpn --version | head -n 1; \
    cat /etc/debian_version; \
    rm -rf /var/lib/apt/lists/*

COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod 0755 /usr/local/bin/entrypoint.sh

ENV TZ=Europe/Madrid \
    OVPN_CONFIG=/config/client.ovpn \
    OVPN_AUTH=/config/auth.txt \
    LAN_SUBNET=192.168.178.0/24

ENTRYPOINT ["/usr/bin/tini","--","/usr/local/bin/entrypoint.sh"]
