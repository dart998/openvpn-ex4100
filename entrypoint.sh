#!/bin/sh
set -eu

log() {
  printf '%s\n' "$*"
}

OVPN_AUTH="${OVPN_AUTH:-/config/auth.txt}"

if [ ! -c /dev/net/tun ]; then
  log "ERROR: /dev/net/tun no existe"
  exit 1
fi

if [ ! -f "$OVPN_CONFIG" ]; then
  log "ERROR: no existe $OVPN_CONFIG"
  exit 1
fi

if [ ! -f "$OVPN_AUTH" ]; then
  log "ERROR: no existe $OVPN_AUTH"
  exit 1
fi

if [ ! -x /etc/openvpn/update-resolv-conf ]; then
  log "ERROR: falta /etc/openvpn/update-resolv-conf"
  exit 1
fi

if ! command -v resolvconf >/dev/null 2>&1; then
  log "ERROR: falta resolvconf"
  exit 1
fi

DEFAULT_ROUTE="$(ip -4 route show default | head -n 1)"
DEFAULT_GW="$(printf '%s\n' "$DEFAULT_ROUTE" | awk '{for (i=1;i<=NF;i++) if ($i=="via") print $(i+1)}')"
DEFAULT_IF="$(printf '%s\n' "$DEFAULT_ROUTE" | awk '{for (i=1;i<=NF;i++) if ($i=="dev") print $(i+1)}')"

if [ -z "$DEFAULT_GW" ] || [ -z "$DEFAULT_IF" ]; then
  log "ERROR: no se pudo detectar la ruta por defecto"
  exit 1
fi

log "Ruta por defecto: gateway=$DEFAULT_GW interfaz=$DEFAULT_IF"
log "LAN fuera de la VPN: $LAN_SUBNET"
log "Configuración Proton sin modificar; resolvconf activo"

ip -4 route replace "$LAN_SUBNET" via "$DEFAULT_GW" dev "$DEFAULT_IF"

exec openvpn \
  --config "$OVPN_CONFIG" \
  --auth-user-pass "$OVPN_AUTH" \
  --auth-nocache \
  --route "$LAN_SUBNET" net_gateway \
  --pull-filter ignore "route-ipv6" \
  --pull-filter ignore "ifconfig-ipv6" \
  --pull-filter ignore "redirect-gateway-ipv6"
