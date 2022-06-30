FROM debian:stable-slim

ADD ./profile/*.sh /etc/profile.d/
ADD ./profile/.bashrc /root/
ENV ENV="/etc/profile"
ENV DEBIAN_FRONTEND="noninteractive"

RUN apt-get update && apt-get install -y \
    iproute2 iptables busybox dnsmasq curl vim nano rsync && \
    rm -rf /var/lib/apt/lists/*
