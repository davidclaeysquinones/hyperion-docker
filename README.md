# hyperion-docker

![Hyperion](https://github.com/hyperion-project/hyperion.ng/blob/master/doc/logo_dark.png?raw=true#gh-dark-mode-only)
![Hyperion](https://github.com/hyperion-project/hyperion.ng/blob/master/doc/logo_light.png?raw=true#gh-light-mode-only)

This is a simple repository containing the source files that enable you tu run [hyperiong.ng](https://github.com/hyperion-project/hyperion.ng/#readme) in a docker container.
You can choose between building the image yourself or using the image that's published in this repository.

This repository initially was based on the work of [psychowood](https://github.com/psychowood/hyperion.ng-docker).
Upon putting further thought into it seemed necesasary to use a custom build instead of the official deb packages.


The image has the following characteristics:

1. It's based on the [official Debian 13 (trixie) docker image](https://hub.docker.com/_/debian)
2. It includes a custom build of hyperion designed to take away uncecesarry dependencies
3. Maps the `/config` dirctory as an external volume, to keep your settings
4. It disables network segmentation so that by default you don't have to use special network settings
5. Runs hyperiond service as non-root user. Default UID:GID are 1000:1000 but they can be easily changed through environment variables

A mirror of this repository can be found in [github](https://github.com/davidclaeysquinones/hyperion-docker).

The image is distributed in the following container registries :
 - [gitea](https://git.claeyscloud.com/david/-/packages/container/hyperion-docker/latest)
 - [github](https://github.com/davidclaeysquinones/hyperion-docker/pkgs/container/hyperion-docker)
 - [docker hub](https://hub.docker.com/repository/docker/davidquinonescl/hyperion-docker/general)

### Standard configuration

start the container with `docker compose up -d` with the following `docker-compose.yml` :
```yaml
version: '3.3'
services:
  hyperionng:
    image: git.claeyscloud.com/david/hyperion-docker
    #image: ghcr.io/davidclaeysquinones/hyperion-docker:latest
    #image: davidquinonescl/hyperion-docker
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

### Security considerations

#### Network segmentation

By default Hyperion uses network segmentation in order to improve security with mDNS and SSDP.
In a standard setup (outside of a Docker environment) this makes sense since you wouldn't want accept packets from other networks.
However in a Docker environment this makes things more complicated since unless you use host mode or specific network setup all requests would be rejected.
In order to make setup more straightforward network segmentation has been disabled. This doesn't mean that you should expose your container to the internet !

#### Supply chain attacks

This repository is made in good faith and only intends to provide something useful.
However you should never take something from the internet without having a good look at it.
So review the source code in order to make sure nothing fishy is going on.
Furthermore the build process includes downloading and compiling the source code.
In most cases this will be just fine but if you're worried about supply chain attacks that is definitely a risk. 
