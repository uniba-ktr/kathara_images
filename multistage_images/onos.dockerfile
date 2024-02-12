ARG image=unibaktr/debian
ARG ZULU_TAG=11.0.13-11.52.13

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


FROM azul/zulu-openjdk:${ZULU_TAG} AS builder
ARG ONOS_VERSION=2.5.9
ARG JOBS=2
ARG PROFILE=default
ARG JAVA_PATH=/usr/lib/jvm/zulu11

#RUN sed -i '/stable stable-updates unstable/!s/stable stable-updates/& unstable/' /etc/apt/sources.list.d/debian.sources

#RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 0xB1998361219BD9C9 && \
#    curl -sLO https://cdn.azul.com/zulu/bin/zulu-repo_${ZULU_REPO_VER}_all.deb && \
#    dpkg -i zulu-repo_${ZULU_REPO_VER}_all.deb

RUN apt-get update && \
    apt-get install -y ca-certificates zip python3 git bzip2 curl unzip build-essential

RUN curl -L -o bazelisk https://github.com/bazelbuild/bazelisk/releases/download/v1.19.0/bazelisk-linux-amd64
RUN chmod +x bazelisk && mv bazelisk /usr/bin
RUN mkdir /src && cd /src && git clone --depth 1 --branch ${ONOS_VERSION} https://gerrit.onosproject.org/onos

# Build-stage environment variables
ENV ONOS_ROOT /src/onos
ENV BUILD_NUMBER docker
ENV JAVA_TOOL_OPTIONS=-Dfile.encoding=UTF8

WORKDIR ${ONOS_ROOT}

RUN cat WORKSPACE-docker >> WORKSPACE
RUN bazelisk build onos \
    --jobs ${JOBS} \
    --verbose_failures \
    --java_runtime_version=dockerjdk_11 \
    --tool_java_runtime_version=dockerjdk_11 \
    --define profile=${PROFILE}
#
RUN mkdir /output
RUN tar -xf bazel-bin/onos.tar.gz -C /output --strip-components=1

## Second and final stage is the runtime environment.
FROM $image
ARG JAVA_PATH=/usr/lib/jvm/zulu11
ARG ZULU_REPO_VER=1.0.0-3

#RUN sed -i '/stable stable-updates unstable/!s/stable stable-updates/& unstable/' /etc/apt/sources.list.d/debian.sources

RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 0xB1998361219BD9C9 && \
    curl -sLO https://cdn.azul.com/zulu/bin/zulu-repo_${ZULU_REPO_VER}_all.deb && \
    dpkg -i zulu-repo_${ZULU_REPO_VER}_all.deb && \
    rm zulu-repo_${ZULU_REPO_VER}_all.deb

RUN apt-get update && apt-get install -y curl zulu11-jre openssh-server supervisor dmidecode && \
    rm -rf /var/lib/apt/lists/*

ADD onos/supervisord.conf /etc/supervisord.conf

COPY --from=hsflow /packages /packages

RUN dpkg -i /packages/*.deb && \
    rm -rf /packages

# Install ONOS in /root/onos
COPY --from=builder /output/ /root/onos/
WORKDIR /root/onos

# Set JAVA_HOME (by default not exported by zulu images)
ENV JAVA_HOME ${JAVA_PATH}

# Ports
# 6653 - OpenFlow
# 6640 - OVSDB
# 8181 - GUI
# 8101 - ONOS CLI
# 9876 - ONOS intra-cluster communication
EXPOSE 6653 6640 8181 8101 9876

# Run ONOS
ENTRYPOINT /usr/bin/supervisord -c /etc/supervisord.conf
#ENTRYPOINT ["./bin/onos-service"]
#CMD ["server"]
