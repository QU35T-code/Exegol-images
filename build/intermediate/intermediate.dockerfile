# Author: The Exegol Project


ARG TAG
ARG ARCH

FROM exegol-base:${TAG}-${ARCH} as build

ARG PACKAGE
RUN echo "PACKAGE is: $PACKAGE"
COPY sources /root/sources/
WORKDIR /root/sources/install
RUN chmod +x entrypoint.sh
RUN ./entrypoint.sh package_${PACKAGE}
RUN ./entrypoint.sh post_install
RUN chmod +x ../assets/exegol/export_tools.sh
RUN ../assets/exegol/export_tools.sh

FROM alpine:3.17.2

WORKDIR /tmp
COPY --from=build /tmp/resources/ /tmp/resources/