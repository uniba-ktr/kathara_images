FROM alpine as build
ENV URL https://github.com/SoftEtherVPN/SoftEtherVPN_Stable/releases/download/
ENV VERSION 5.01.9674
ENV USE_MUSL YES

RUN apk add --no-cache alpine-sdk cmake rpm ncurses-dev openssl-dev zlib-dev readline-dev &&\
    git clone -b ${VERSION} --depth 1 https://github.com/SoftEtherVPN/SoftEtherVPN.git
WORKDIR SoftEtherVPN
RUN git submodule update --init --recursive && \
    ./configure && \
    make -C tmp && \
    make -C tmp install

FROM unibaktr/alpine

COPY --from=build /SoftEtherVPN/build /tmp

RUN apk add --no-cache readline curl && \
    mv /tmp/*.so /usr/lib/ && \
    mv /tmp/vpn* /tmp/*.se2 /usr/local/bin/

WORKDIR /softether
EXPOSE 443/tcp 992/tcp 1194/tcp 1194/udp 5555/tcp 500/udp 4500/udp
