FROM debian:stable-slim

ADD ./profile/*.sh /etc/profile.d/
ENV ENV="/etc/profile"
ENV DEBIAN_FRONTEND="noninteractive"

RUN apt-get update && apt-get install -y \
    iproute2 iptables busybox dnsmasq curl vim nano rsync && \
    apt-get clean

#RUN apk add --no-cache busybox bash curl bind-tools iptables dnsmasq vim nano rsync
