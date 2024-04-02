ARG image=unibaktr/alpine

FROM $image

ADD https://inmon.com/products/sFlow-RT/sflow-rt.tar.gz sflow-rt.tar.gz

RUN apk add -U openjdk11-jre && \
    tar -xzvf sflow-rt.tar.gz

RUN /sflow-rt/get-app.sh sflow-rt browse-metrics && \
    /sflow-rt/get-app.sh sflow-rt browse-flows && \
    /sflow-rt/get-app.sh sflow-rt ddos-protect && \
    /sflow-rt/get-app.sh sflow-rt particle

ENTRYPOINT ./sflow-rt/start.sh
