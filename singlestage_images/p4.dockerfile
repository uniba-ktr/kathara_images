ARG image=unibaktr/ubuntu
FROM $image

RUN echo 'deb https://download.opensuse.org/repositories/home:/p4lang/xUbuntu_22.04/ /' > /etc/apt/sources.list.d/home:p4lang.list
RUN curl -fsSL https://download.opensuse.org/repositories/home:p4lang/xUbuntu_22.04/Release.key | gpg --dearmor | tee /etc/apt/trusted.gpg.d/home_p4lang.gpg > /dev/null
RUN apt-get update && apt-get install -y p4lang-p4c p4lang-bmv2 && \
    apt clean && \
    rm -rf /tmp/* /var/lib/apt/lists/* /var/tmp/

RUn python3 -m pip install --no-cache-dir p4runtime
