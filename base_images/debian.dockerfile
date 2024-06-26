FROM debian:stable-slim

ARG DEBIAN_FRONTEND="noninteractive"

ADD ./profile/*.sh /etc/profile.d/
ADD ./profile/.bashrc /root/
ENV ENV="/etc/profile"
ENV DEBIAN_FRONTEND="noninteractive"

RUN apt-get update && apt-get install -y \
    iproute2 iptables busybox dnsmasq curl vim nano rsync gpg procps iperf net-tools tcpdump traceroute iputils-ping iputils-tracepath python3 python3-pip && \
    rm -rf /var/lib/apt/lists/*

RUN python3 -m pip install --break-system-packages --no-cache-dir scapy


WORKDIR /

VOLUME /hosthome
VOLUME /shared
