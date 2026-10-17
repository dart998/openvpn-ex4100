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

Current stable image: `ovelayos/gluetun-wd-ex4100:3.41.3-ex4100-r2`

## Portainer

Portainer can use the repository root directly because `docker-compose.yml` is present at the top level. A copy is also kept in `compose/portainer-stack.yml`.

The WireGuard configuration is intentionally **not** stored in this repository. Put the configuration on the NAS at:

`/mnt/HD/HD_a2/Public/gluetun/wireguard/wg0.conf`

The stack mounts that file inside Gluetun as:

`/gluetun/wireguard/wg0.conf`

Important: the host path must be an actual file. If it does not exist when Docker starts the stack, Docker may create a directory with that name and Gluetun will report `wg0.conf: is a directory`.

## Updating

The GitHub Actions workflow checks upstream Gluetun releases, builds only `linux/arm/v7`, smoke-tests the image, publishes the EX4100 image to Docker Hub, updates both stable Portainer stack files and optionally calls the Portainer webhook.
