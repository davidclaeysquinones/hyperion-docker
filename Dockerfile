FROM debian:bookworm

COPY start.sh .
RUN export DEBIAN_FRONTEND=noninteractive && \
    apt-get update && \
    apt-get upgrade -y -q && \
    apt-get install -y wget curl sudo gpg apt-transport-https lsb-release && \
    wget -qO /tmp/hyperion.pub.key https://releases.hyperion-project.org/hyperion.pub.key  && \
    gpg --dearmor -o /usr/share/keyrings/hyperion.pub.gpg /tmp/hyperion.pub.key && \
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/hyperion.pub.gpg] https://apt.releases.hyperion-project.org/ $(lsb_release -cs) main"  > /etc/apt/sources.list.d/hyperion.list && \
    apt-get update && \
    apt-get install -y hyperion && \
    groupadd -f hyperion && \
    useradd -r -s /bin/bash -g hyperion hyperion && \
    chmod 777 /start.sh && \
    mkdir /config && \
    apt-get clean && \
    rm -rf /var/cache/apk/*


# Flatbuffers Server port
EXPOSE 19400

# JSON-RPC Server Port
EXPOSE 19444

# Protocol Buffers Server port
EXPOSE 19445

# Boblight Server port
EXPOSE 19333

# Philips Hue Entertainment mode (UDP)
EXPOSE 2100

# HTTP and HTTPS Web UI default ports
EXPOSE 8090
EXPOSE 8092

ENV UID=1000
ENV GID=1000

SHELL ["/bin/bash", "-c"]
ENTRYPOINT bash start.sh uid="$UID" gid="$GID"
