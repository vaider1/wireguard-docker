# Wireguard-Docker
A Docker image of Wireguard VPN router based on an Alpine Linux image created by linuxserver.io

[Docker Hub image](https://hub.docker.com/r/vaider1/wireguard-docker)

## Overview
Super simple to use Docker image that creates a VPN server based on Wireguard.

## Host requirements
Wireguard kernel module - The container guest depends on the kernel modules of the host so the guest needs it to be able to create a Wireguard interface.

# Parameters
## Environment variables
| Variable | Default Value | Description |
|---|---|---|
| PUID | 911 | User ID that the container will run under |
| PGID | 911 | Group ID that the container will run under |
| TZ | Europe/London | Time zone to set for hte container |
| WG_PRIVKEY | Randomly Generated | Server private key (wg genkey), if a key isn't provided, each start of the container a new pair will be generated |
| WG_ROUTER_IP | 192.168.77.254/32 | The IP of the router, must correlate with the wanted subnet CIDR of the VPN network |

## Volumes
| Path | Description |
|---|---|
| /config/peers | Files should hold information about the peers that the server will connect to, each start of the container the content of the files are added to the Wireguard configuration file |

## Ports
| Port | Proto | Description |
|---|---|---|
| 51820 | UDP | Wireguard tunnel listening port |

# Usage
The containers logs will print the public key of the server each start to provide to the clients.

## Docker example
```
docker create \
  --name wireguard \
  --cap-add NET_ADMIN \
  -v </path/to/wireguard/config>:/config \
  -e PUID=1000 \
  -e PGID=1000 \
  -e TZ=Europe/London \
  -e WG_ROUTER_IP=192.168.7.254/32 \
  -e WG_PRIVKEY=** Private Key ** \
  -p 51820:51820/udp \
  vaider1/wireguard-docker:latest
```

## Docker-compose example
```
version: "3.3"
services:
  wireguard:
    image: vaider1/wireguard-docker:latest
    cap_add:
    - NET_ADMIN
    container_name: wireguard
    environment:
    - PUID=1000
    - PGID=1000
    - TZ=Europe/London
    - WG_ROUTER_IP=192.168.7.254/32
    - WG_PRIVKEY=** Private Key **
    volumes:
    - /home/john/containers/wireguard/config:/config
    ports:
    - "51820:51820/udp"
    restart: unless-stopped
networks:
  default:
    driver: bridge
```

## Peer file example
```
# HOSTNAME
[Peer]
PublicKey = ** Public Key **
PresharedKey = ** PSK (wg genpsk) **
AllowedIPs = 192.168.7.1/32, 10.0.0.0/16
```

## Notes


### Contact