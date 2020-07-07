FROM unibaktr/alpine

RUN apk add --no-cache radvd dhcpcd && \
    mkdir -p /run/radvd
