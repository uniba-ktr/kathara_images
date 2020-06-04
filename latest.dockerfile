FROM alpine

RUN apk add --no-cache busybox bash curl bind-tools iptables dnsmasq vim nano rsync
