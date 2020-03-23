FROM quay.io/pypa/manylinux1_x86_64:latest

WORKDIR /io

COPY scripts/install.sh /tmp/.
RUN bash /tmp/install.sh
RUN rm /tmp/install.sh

COPY scripts/build_wheels.sh /usr/local/bin/.
RUN chmod +x /usr/local/bin/build_wheels.sh

ENTRYPOINT ["/bin/bash"]
