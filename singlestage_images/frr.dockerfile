ARG image=unibaktr/alpine
FROM $image

RUN echo "@edge http://dl-cdn.alpinelinux.org/alpine/edge/main" >> /etc/apk/repositories && \
    echo "@community http://dl-cdn.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories && \
    apk add --no-cache json-c@edge frr@community bind-libs frr-pythontools@community busybox-extras && \
    #ln -s /usr/bin/python3 /usr/bin/python && \
    echo "no service integrated-vtysh-config" > /etc/frr/vtysh.conf && \
    echo "export PATH=\"$PATH:/usr/lib/frr/\"" > /etc/profile.d/frrpath.sh && \
    mkdir /var/log/frr/

ENV PATH="$PATH:/usr/lib/frr/"
