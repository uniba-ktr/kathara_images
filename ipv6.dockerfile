FROM unibaktr/alpine

RUN apk add --no-cache radvd dhcpcd dhcp && \
    mkdir -p /run/radvd
