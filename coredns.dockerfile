FROM unibaktr/alpine
ENV URL=https://github.com/coredns/coredns/releases/download/
ENV VERSION=1.6.9

RUN cd /tmp && \
    export ARCH=$(echo $(uname -m) | sed -e "s|armv[5-7].*|arm|g" -e "s|aarch64|arm64|g" -e "s|x86_64|amd64|g" ) && \
    wget -qO coredns.tgz ${URL}v${VERSION}/coredns_${VERSION}_linux_$ARCH.tgz && \
    tar xf coredns.tgz && \
    mv coredns /bin/ && \
    rm /tmp/*
