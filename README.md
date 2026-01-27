# hyperion-docker

This repository is based on the work of [psychowood](https://github.com/psychowood/hyperion.ng-docker) although it has suffered some modifications.

![Hyperion](https://github.com/hyperion-project/hyperion.ng/blob/master/doc/logo_dark.png?raw=true#gh-dark-mode-only)
![Hyperion](https://github.com/hyperion-project/hyperion.ng/blob/master/doc/logo_light.png?raw=true#gh-light-mode-only)

This is a simple repository containining some the source files that enable you tu run [hyperiong.ng](https://github.com/hyperion-project/hyperion.ng/#readme) in a docker container.
You can choose between building the image yourself or using the image that's published in this repositoru.

The image is quite simple:

1. It's based on the [official Debian 12 (bookworm) docker image](https://hub.docker.com/_/debian)
2. It downloads the hyperion official package from the [official hyperion apt package repository](https://apt.releases.hyperion-project.org/)
3. Maps the `/config` dirctory as an external volume, to keep your settings
4. Runs hyperiond service as non-root user. Default UID:GID are 1000:1000 but they can be easily changed through environment variables

Sadly, the resulting image is not exaclty slim at ~500MB, because hyperion has lots of dependencies. Since many of them are for the Desktop/Qt UI, it should be possible to slim the image up by cherry picking the ones not used but the cli service, but that's probably not really worth it.

On the other hand, the running service does not need lots of RAM (on my system takes ~64MB without the cache).

You have different options to run this image, after starting the container you can reach the web ui going either to http://youdockerhost:8090 or https://youdockerhost:8092

### Standard configuration


```
start the container with `docker compose up -d` with the following `docker-compose.yml` :
```yaml
version: '3.3'

services:
  hyperionng:
    image: git.claeyscloud.com/david/hyperion-docker
    volumes:
      - /docker/hyperion:/config
    ports:
      - "19400:19400"
      - "19444:19444"
      - "19445:19445"
      - "8090:8090"
      - "8092:8092"
      Philips Hue in Entertainment mode
      #- "2100:2100"
    restart: unless-stopped
```


You may want to adapt the "ports" section adding other port mappings for specific cases (e.g. "2100:2100/udp" for Philips Hue in Entertainment mode).

An alternative, especially if you need advanced functions like mDNS and SSDP services, could be running the cointainer in a macvlan network bridged to your local one. The following is an example that exposes the hyperionng container with the 192.168.1.17 IP in a local network 192.168.1.0/24 with the gateway 192.168.1.1, please adapt the configuration to your specific case.

```yaml
version: '3.3'

services:
  hyperionng:
    image: hyperionng:latest
    container_name: hyperionng
    volumes:
      - hyperionng-config:/config
    networks:
      mylannet:
         ipv4_address: 192.168.1.17
    restart: unless-stopped
volumes:
  hyperionng-config:
# define networks
networks:
  mylannet:
    name: mylannet
    driver: macvlan
    driver_opts:
      parent: eth0
    ipam:
      config:
        - subnet: 192.168.1.0/24
          gateway: 192.168.1.1
          ip_range: 192.168.1.64/26
```

Moreover, if you want to use some hardware devices (USB. serial, video, and so on), you need to passthrough the correct one adding a devices section in the compose file (the following is jut an example):

```yaml
devices:
      - /dev/ttyACM0:/dev/ttyACM0
      - /dev/video1:/dev/video1
      - /dev/ttyUSB1:/dev/ttyUSB0
      - /dev/spidev0.0:/dev/spidev0.0 
```

If you want to use different UID and GID, you can add a `.env` file in the same folder of your `docker-compose.yml` file:

```properties
UID=1100
GID=1100
```
