ARG image=unibaktr/alpine
FROM $image
ENV URL=https://github.com/containous/traefik/releases/download/
ENV VERSION=v2.2.1

RUN cd /tmp && \
    export ARCH=$(echo $(uname -m) | sed -e "s|\(armv[5-7]\).*|\1|g" -e "s|aarch64|arm64|g" -e "s|x86_64|amd64|g" ) && \
    wget -qO- ${URL}${VERSION}/traefik_${VERSION}_linux_$ARCH.tar.gz | tar xzf - && \
    mv traefik /bin/ && \
    rm /tmp/*
