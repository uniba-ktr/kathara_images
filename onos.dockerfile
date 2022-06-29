FROM unibaktr/debian AS builder
ARG JOBS=2
ARG PROFILE=default
ARG TAG=11.0.8-11.41.23
ARG JAVA_PATH=/usr/lib/jvm/java-11-openjdk-amd64

RUN apt-get install -y ca-certificates zip python python3 git bzip2 curl unzip openjdk-11-jdk build-essential

RUN curl -L -o bazelisk https://github.com/bazelbuild/bazelisk/releases/download/v1.12.0/bazelisk-linux-amd64
RUN chmod +x bazelisk && mv bazelisk /usr/bin
RUN mkdir /src && cd /src && git clone https://gerrit.onosproject.org/onos

WORKDIR /src/onos

RUN bazelisk build onos \
    --jobs ${JOBS} \
    --verbose_failures \
    --javabase=@bazel_tools//tools/jdk:absolute_javabase \
    --host_javabase=@bazel_tools//tools/jdk:absolute_javabase \
    --define=ABSOLUTE_JAVABASE=${JAVA_PATH} \
    --define profile=${PROFILE}

RUN mkdir /output
RUN tar -xf bazel-bin/onos.tar.gz -C /output --strip-components=1

## Second and final stage is the runtime environment.
FROM unibaktr/debian

RUN apt-get update && apt-get install -y curl openjdk-11-jre openssh-server && \
    rm -rf /var/lib/apt/lists/*

# Install ONOS in /root/onos
COPY --from=builder /output/ /root/onos/
WORKDIR /root/onos

# Set JAVA_HOME (by default not exported by zulu images)
ARG JAVA_PATH=/usr/lib/jvm/java-11-openjdk-amd64
ENV JAVA_HOME ${JAVA_PATH}

# Ports
# 6653 - OpenFlow
# 6640 - OVSDB
# 8181 - GUI
# 8101 - ONOS CLI
# 9876 - ONOS intra-cluster communication
EXPOSE 6653 6640 8181 8101 9876

# Run ONOS
ENTRYPOINT ["./bin/onos-service"]
CMD ["server"]
