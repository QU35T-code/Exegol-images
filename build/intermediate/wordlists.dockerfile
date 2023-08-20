# Author: The Exegol Project

FROM exegol-base:PR1-arm64 as build

COPY sources /root/sources/
WORKDIR /root/sources/install
RUN chmod +x entrypoint.sh
RUN ./entrypoint.sh package_wordlists
RUN ./entrypoint.sh post_install
RUN chmod +x ../assets/exegol/export_tools.sh
RUN ../assets/exegol/export_tools.sh

FROM alpine:3.17.2

WORKDIR /tmp
COPY --from=build /tmp/resources/ /tmp/resources/