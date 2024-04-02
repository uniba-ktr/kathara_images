ARG image=unibaktr/alpine
ARG ALPINE_VERSION=3.19

FROM golang:alpine${ALPINE_VERSION} as build
RUN apk --update add \
      libpcap-dev \
      build-base \
      linux-headers \
      gcc \
      git \
      openssl-dev \
      util-linux-dev
RUN git clone --depth=1 --branch=master https://github.com/sflow/host-sflow.git
WORKDIR host-sflow
RUN make all install FEATURES="DOCKER PCAP OVS TCP DROPMON CONTAINERD CONTAINERDGO K8S" PROCFS=/rootproc

FROM $image as complete
COPY --from=build /usr/sbin/hsflowd_containerd /usr/sbin/hsflowd_containerd
COPY --from=build /usr/sbin/hsflowd /usr/sbin/hsflowd
COPY --from=build /etc/hsflowd/ /etc/hsflowd/
COPY ovs/start.sh /
COPY ovs/supervisord.conf /etc/supervisord.conf
RUN apk add --no-cache tini dmidecode libpcap libuuid uuidgen supervisor openvswitch && \
    chmod +x /start.sh && \
    ln -s /proc /rootproc && \
    /usr/bin/ovsdb-tool create /etc/openvswitch/conf.db && \
    mkdir -pv /var/run/openvswitch/


#HEALTHCHECK CMD pidof hsflowd > /dev/null || exit 1
#CMD ["/sbin/tini","--","/start.sh"]
ENTRYPOINT /usr/bin/supervisord -c /etc/supervisord.conf
