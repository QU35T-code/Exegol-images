# Author: The Exegol Project

ARG TAG
ARG ARCH

FROM exegol-base:${TAG}-${ARCH} as build

ARG PACKAGE_NAME

COPY sources /root/sources/
WORKDIR /root/sources/install
RUN chmod +x entrypoint.sh
RUN ./entrypoint.sh package_${PACKAGE_NAME}
RUN ./entrypoint.sh post_install
RUN chmod +x ../assets/exegol/export_tools.sh
RUN ../assets/exegol/export_tools.sh