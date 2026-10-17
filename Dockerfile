# syntax=docker/dockerfile:1

FROM debian:bullseye-slim

LABEL org.opencontainers.image.title="OpenVPN client for WD My Cloud EX4100" \
      org.opencontainers.image.description="Minimal ARMv7 OpenVPN gateway for WD My Cloud EX4100" \
      org.opencontainers.image.source="https://github.com/dart998/openvpn-ex4100" \
      org.opencontainers.image.version="1.1.0"

ENV DEBIAN_FRONTEND=noninteractive

RUN set -eux; \
    printf '%s\n' \
      'deb http://archive.debian.org/debian bullseye main' \
      'deb http://archive.debian.org/debian bullseye-updates main' \
      'deb http://archive.debian.org/debian-security bullseye-security main' \
      > /etc/apt/sources.list; \
    printf '%s\n' 'Acquire::Check-Valid-Until "false";' > /etc/apt/apt.conf.d/99archive; \
    apt-get update; \
    apt-get install -y --no-install-recommends \
      ca-certificates \
      iproute2 \
      iptables \
      openresolv \
      openvpn \
      tini \
      tzdata; \
    update-alternatives --set iptables /usr/sbin/iptables-legacy; \
    update-alternatives --set ip6tables /usr/sbin/ip6tables-legacy; \
    update-ca-certificates; \
    mkdir -p /config; \
    test -x /etc/openvpn/update-resolv-conf; \
    test -x /sbin/resolvconf; \
    /usr/sbin/iptables --version; \
    /usr/sbin/iptables-legacy --version; \
    openvpn --version | head -n 1; \
    cat /etc/debian_version; \
    rm -rf /var/lib/apt/lists/*

COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod 0755 /usr/local/bin/entrypoint.sh

ENV TZ=Europe/Madrid \
    OVPN_CONFIG=/config/client.ovpn \
    LAN_SUBNET=192.168.178.0/24

ENTRYPOINT ["/usr/bin/tini","--","/usr/local/bin/entrypoint.sh"]
