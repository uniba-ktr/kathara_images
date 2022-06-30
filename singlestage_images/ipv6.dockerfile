FROM unibaktr/alpine

RUN apk add --no-cache radvd dhcpcd dhcp && \
    mkdir -p /run/radvd && \
    touch /var/lib/dhcp/dhcpd6.leases
