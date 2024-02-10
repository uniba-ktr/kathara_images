ARG image=unibaktr/debian

FROM $image AS hsflow
RUN apt-get -y update && apt-get install -y --no-install-recommends \
      build-essential \
      git-all \
      libpcap-dev \
      libvirt-dev \
      libnfnetlink-dev \
      libxml2-dev \
      libssl-dev \
      libdbus-1-dev \
      uuid-dev \
      dmidecode
RUN mkdir /packages && chown 777 /packages
COPY ovs/build_hsflowd /root/build_hsflowd
RUN chmod +x /root/build_hsflowd && \
    /root/build_hsflowd


FROM $image

#RUN apk add --no-cache openvswitch supervisor
RUN apt-get -y update && apt-get install -y --no-install-recommends \
    openvswitch-switch supervisor dmidecode

RUN /usr/bin/ovsdb-tool create /etc/openvswitch/conf.db && \
    mkdir -pv /var/run/openvswitch/

ADD ovs/supervisord.conf /etc/supervisord.conf

COPY --from=hsflow /packages /packages

RUN dpkg -i /packages/*.deb && \
    rm -rf /packages

ENTRYPOINT /usr/bin/supervisord -c /etc/supervisord.conf
