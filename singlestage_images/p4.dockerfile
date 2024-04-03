ARG image=unibaktr/ubuntu
FROM $image

RUN echo 'deb https://download.opensuse.org/repositories/home:/p4lang/xUbuntu_22.04/ /' > /etc/apt/sources.list.d/home:p4lang.list
RUN curl -fsSL https://download.opensuse.org/repositories/home:p4lang/xUbuntu_22.04/Release.key | gpg --dearmor | tee /etc/apt/trusted.gpg.d/home_p4lang.gpg > /dev/null
RUN apt-get update && apt-get install -y p4lang-p4c p4lang-bmv2 && \
    apt clean && \
    rm -rf /tmp/* /var/lib/apt/lists/* /var/tmp/

RUN python3 -m pip install --no-cache-dir p4runtime
#	git clone https://github.com/p4lang/tutorials.git && \
#	mv tutorials/utils/p4runtime_lib /usr/local/lib/python3.7/site-packages/p4runtime_lib && \
#	rm -Rf tutorials

ENV PROTOCOL_BUFFERS_PYTHON_IMPLEMENTATION python
ENV PYTHONPATH $PYTHONPATH:/usr/local/lib/python3.10/site-packages/
