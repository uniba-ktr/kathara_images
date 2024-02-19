FROM alpine

ADD ./profile/*.sh /etc/profile.d/
ADD ./profile/.bashrc /root/
ENV ENV="/etc/profile"

RUN echo "@testing https://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories && \
    apk add --no-cache busybox bash curl bind-tools iptables dnsmasq iperf vim nano rsync tcpdump python3 py3-pip \
        hping3@testing

RUN python3 -m pip install --break-system-packages --no-cache-dir scapy


WORKDIR /

VOLUME /hosthome
VOLUME /shared
