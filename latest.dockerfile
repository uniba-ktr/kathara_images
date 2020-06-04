FROM alpine

ADD ./profile/kathara.rc /root/.ashrc
ENV ENV="/root/.ashrc"

RUN apk add --no-cache busybox bash curl bind-tools iptables dnsmasq vim nano rsync
