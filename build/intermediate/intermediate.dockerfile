# Author: The Exegol Project

ARG PACKAGE_NAME="nothing"
ARG TAG="12"
ARG ARCH="arm54"

FROM exegol-base:${TAG}-${ARCH} as build

COPY sources /root/sources/
WORKDIR /root/sources/install
RUN chmod +x entrypoint.sh
RUN ./entrypoint.sh package_${PACKAGE_NAME}
RUN ./entrypoint.sh post_install
RUN chmod +x ../assets/exegol/export_tools.sh
RUN ../assets/exegol/export_tools.sh

FROM alpine:3.17.2

WORKDIR /tmp
COPY --from=build /tmp/resources/ /tmp/resources/