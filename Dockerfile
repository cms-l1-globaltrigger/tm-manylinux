FROM quay.io/pypa/manylinux1_x86_64:latest

WORKDIR /io

COPY scripts/install_*.sh /tmp/
RUN bash /tmp/install_deps.sh
RUN bash /tmp/install_xsd.sh
RUN bash /tmp/install_boost.sh
RUN bash /tmp/install_xerces_c.sh
RUN bash /tmp/install_swig.sh
RUN rm /tmp/install_*.sh

COPY scripts/build_wheels.sh /usr/local/bin/.
RUN chmod +x /usr/local/bin/build_wheels.sh

ENTRYPOINT ["/bin/bash"]
