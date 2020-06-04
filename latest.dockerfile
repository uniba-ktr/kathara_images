FROM alpine

ADD ./profile/*.sh /etc/profile.d/
ENV ENV="/etc/profile"

RUN apk add --no-cache busybox bash curl bind-tools iptables dnsmasq vim nano rsync
