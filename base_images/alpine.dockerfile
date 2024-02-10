FROM alpine

ADD ./profile/*.sh /etc/profile.d/
ADD ./profile/.bashrc /root/
ENV ENV="/etc/profile"

RUN apk add --no-cache busybox bash curl bind-tools iptables dnsmasq iperf vim nano rsync tcpdump python3 py3-pip

RUN python3 -m pip install --break-system-packages --no-cache-dir scapy


WORKDIR /

VOLUME /hosthome
VOLUME /shared
