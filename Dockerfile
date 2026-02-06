FROM  debian:trixie AS builder
COPY build.sh .
RUN apt-get update && \
    apt-get upgrade -y -q && \
    chmod +x build.sh && \
    bash build.sh


FROM debian:trixie
COPY start.sh .
COPY initialconfig.json .
COPY --from=builder /usr/bin/hyperiond /usr/bin/hyperiond
RUN apt-get update && \
    apt-get upgrade -y -q && \
    apt-get install -y sudo tzdata libfontconfig1 libglib-2.0 libproxy1v5 libcec-dev && \
    chmod 755 /usr/bin/hyperiond && \
    groupadd -f hyperion && \
    useradd -r -s /bin/bash -g hyperion hyperion && \
    chmod 777 /start.sh && \
    mkdir /config && \
    chmod 777 /config && \
    apt-get clean && \
    rm -rf /var/cache/apk/* && \
    rm -rf /usr/share/man

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
ENTRYPOINT bash start.sh uid="$UID" gid="$GID" server_address="$SERVER_ADDRESS"
