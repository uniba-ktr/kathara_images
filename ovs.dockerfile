FROM unibaktr/alpine

RUN apk add --no-cache openvswitch supervisor

RUN /usr/bin/ovsdb-tool create /etc/openvswitch/conf.db && \
    mkdir -pv /var/run/openvswitch/

ADD ovs/supervisord.conf /etc/supervisord.conf

ENTRYPOINT /usr/bin/supervisord
