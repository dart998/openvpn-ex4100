# openvpn-ex4100

Cliente OpenVPN ARMv7 mínimo para WD My Cloud EX4100.

Diseñado para funcionar en el kernel limitado del EX4100 sin depender de `ip rule` ni policy routing.

## Características

- Alpine 3.17.10
- OpenVPN 2.5.x
- ARMv7
- `/dev/net/tun`
- `NET_ADMIN`
- IPv4
- Ruta LAN clásica, sin `ip rule`
- Compatible con configuraciones `.ovpn` de Proton VPN

## Archivos en el NAS

Crear:

```text
/mnt/HD/HD_a2/Public/openvpn-ex4100/
```

Dentro:

```text
client.ovpn
auth.txt
```

`client.ovpn` es la configuración OpenVPN descargada del proveedor.

`auth.txt` debe contener dos líneas:

```text
USUARIO_OPENVPN
CONTRASEÑA_OPENVPN
```

No usar las credenciales normales de la cuenta Proton; usar las credenciales específicas de OpenVPN.

## Portainer

Usar el stack:

```text
compose/portainer-stack.yml
```

La imagen por defecto es:

```text
ovelayos/openvpn-ex4100:1.0.0
```

## Compartir la VPN con otro contenedor

Un contenedor que deba usar la VPN puede compartir el namespace de red del cliente OpenVPN:

```yaml
network_mode: "container:openvpn-proton"
```

Los puertos que necesite ese contenedor deben publicarse en el contenedor OpenVPN, no en el contenedor cliente.

## Limitaciones del EX4100

El kernel del WD My Cloud EX4100 no soporta `ip rule`, por lo que este proyecto evita cualquier dependencia de policy routing.
