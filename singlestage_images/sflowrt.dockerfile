ARG image=unibaktr/alpine

FROM $image

ADD https://inmon.com/products/sFlow-RT/sflow-rt.tar.gz sflow-rt.tar.gz

RUN apk add -U openjdk11-jre && \
    tar -xzvf sflow-rt.tar.gz

ENTRYPOINT ./sflow-rt/start.sh
