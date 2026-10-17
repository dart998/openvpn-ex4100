# syntax=docker/dockerfile:1

ARG GLUETUN_VERSION=v3.41.3

FROM --platform=$TARGETPLATFORM qmcgaw/gluetun:${GLUETUN_VERSION} AS upstream

FROM alpine:3.17.10

ARG GLUETUN_VERSION=v3.41.3
ARG EX4100_REVISION=r1

LABEL org.opencontainers.image.title="Gluetun for WD My Cloud EX4100" \
      org.opencontainers.image.description="Gluetun ARMv7 runtime adapted for WD My Cloud EX4100" \
      org.opencontainers.image.source="https://github.com/dart998/gluetun-wd-ex4100" \
      org.opencontainers.image.version="${GLUETUN_VERSION}-ex4100-${EX4100_REVISION}"

RUN apk add --no-cache \
      ca-certificates \
      iptables \
      openvpn \
      tzdata \
    && update-ca-certificates \
    && mkdir -p /gluetun/wireguard

COPY --from=upstream /gluetun-entrypoint /gluetun-entrypoint

RUN chmod 0755 /gluetun-entrypoint \
    && /sbin/iptables --version \
    && /sbin/iptables-legacy --version \
    && grep -Fx '3.17.10' /etc/alpine-release

ENV VPN_SERVICE_PROVIDER=custom \
    VPN_TYPE=wireguard \
    VPN_INTERFACE=tun0 \
    WIREGUARD_IMPLEMENTATION=userspace \
    WIREGUARD_GSO=off \
    TZ=Europe/Madrid

ENTRYPOINT ["/gluetun-entrypoint"]

HEALTHCHECK --interval=10s --timeout=5s --start-period=20s --retries=3 \
  CMD /gluetun-entrypoint healthcheck || exit 1
