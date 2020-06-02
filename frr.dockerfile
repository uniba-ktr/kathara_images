FROM unibaktr/alpine

RUN echo "@edge http://dl-cdn.alpinelinux.org/alpine/edge/main" >> /etc/apk/repositories && \
    echo "@community http://dl-cdn.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories && \
    apk add --no-cache json-c@edge frr@community

CMD ["/usr/lib/frr/frrinit.sh", "start"]
