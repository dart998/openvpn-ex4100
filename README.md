# Gluetun for WD My Cloud EX4100

Custom ARMv7 Gluetun image for WD My Cloud EX4100 systems where the official image's Alpine/iptables userspace crashes with `segmentation fault` on the WD kernel.

## Target

- WD My Cloud EX4100
- Linux `4.14.22-armada-18.09.3`
- `armv7l`
- Docker / Portainer CE
- Docker Hub image: `ovelayos/gluetun-wd-ex4100`

## Compatibility approach

The image takes the statically built Gluetun entrypoint from the selected upstream stable release and runs it on Alpine `3.17.10` with the older iptables/iptables-legacy userspace known to be compatible with this NAS generation.

Current stable image: `ovelayos/gluetun-wd-ex4100:3.41.3-ex4100-r1`

## Portainer

Use `compose/portainer-stack.yml` from `refs/heads/main`.

The WireGuard configuration is intentionally **not** stored in this repository. The stack expects the NAS file:

`/mnt/HD/HD_a2/Public/gluetun/proton-es90.conf`

and mounts it inside Gluetun as:

`/gluetun/wireguard/wg0.conf`

## Updating

The GitHub Actions workflow checks upstream Gluetun releases, builds only `linux/arm/v7`, smoke-tests the image, publishes the EX4100 image to Docker Hub, updates the stable Portainer stack and optionally calls the Portainer webhook.
