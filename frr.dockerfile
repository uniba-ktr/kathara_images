FROM unibaktr/alpine

RUN echo "@edge http://dl-cdn.alpinelinux.org/alpine/edge/main" >> /etc/apk/repositories && \
    echo "@community http://dl-cdn.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories && \
    apk add --no-cache json-c@edge frr@community bind-libs@edge frr-pythontools@community busybox-extras && \
    ln -s /usr/bin/python3 /usr/bin/python && \
    echo "no service integrated-vtysh-config" > /etc/frr/vtysh.conf && \
    echo "export PATH=\"$PATH:/usr/lib/frr/\"" > /etc/profile.d/frrpath.sh

ENV PATH="$PATH:/usr/lib/frr/"
