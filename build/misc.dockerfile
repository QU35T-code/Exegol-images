# Author: The Exegol Project

FROM exegol-base:PR1-arm64 as build

ARG TAG="local"
ARG VERSION="local"
ARG BUILD_DATE="n/a"

LABEL org.exegol.tag="${TAG}"
LABEL org.exegol.version="${VERSION}"
LABEL org.exegol.build_date="${BUILD_DATE}"
LABEL org.exegol.app="Exegol"
LABEL org.exegol.src_repository="https://github.com/ThePorgs/Exegol-images"

COPY sources /root/sources/

WORKDIR /root/sources/install

RUN chmod +x entrypoint.sh

RUN ./entrypoint.sh package_misc

RUN ./entrypoint.sh post_install

RUN chmod +x ../assets/exegol/extract_tools.sh

RUN ../assets/exegol/extract_tools.sh

FROM alpine:3.17.2

WORKDIR /tmp

COPY --from=build /tmp/resources .