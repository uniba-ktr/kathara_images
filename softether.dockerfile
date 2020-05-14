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

FROM alpine

COPY --from=build /SoftEtherVPN/build /tmp

RUN apk add --no-cache readline && \
    mv /tmp/*.so /usr/lib/ && \
    mv /tmp/vpn* /tmp/*.se2 /usr/local/bin/
    #COPY --from=build /usr/local/libexec/softether /usr/local/libexec/softether
WORKDIR /softether
EXPOSE 443/tcp 992/tcp 1194/tcp 1194/udp 5555/tcp 500/udp 4500/udp




#0 export USE_MUSL=YES
#  1 git clone https://github.com/SoftEtherVPN/SoftEtherVPN.git
#  2 apk add --no-cache alpine-sdk
#  3 git clone https://github.com/SoftEtherVPN/SoftEtherVPN.git
#  4 cd SoftEtherVPN/
#  5 git submodule init && git submodule update
#  6 ./configure
#  7 apk add --no-cache cmake
#  8 apk add --no-cache rpm
#  9 ./configure
# 10 apk add --no-cache curses
# 11 apk add --no-cache ncurses
# 12 ./configure
# 13 apk add --no-cache ncurses-dev
# 14 ./configure
# 15 apk add --no-cache openssl-dev
# 16 ./configure
# 17 apk add --no-cache zlib-dev
# 18 ./configur
# 19 apk add --no-cache readline
# 20 ./configur
# 21 ./configure
# 22 apk add --no-cache readline-dev
# 23 ./configure
# 24 make -C tmp
# 25 make -C tmp install
# 26 ls
# 27 /usr/local/bin/vpnserver
# 28 /usr/local/bin/vpnserver start
# 29 history

















#https://github.com/SoftEtherVPN/SoftEtherVPN_Stable/releases/download/v4.34-9745-beta/softether-vpnserver-v4.34-9745-beta-2020.04.05-linux-x64-64bit.tar.gz
