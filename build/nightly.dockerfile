FROM exegol-iot:PR1-arm64 as iot
FROM exegol-misc:PR1-arm64 as misc
FROM exegol-cloud:PR1-arm64 as cloud

FROM exegol-base:PR1-arm64

ARG TAG="local"
ARG VERSION="local"
ARG BUILD_DATE="n/a"

LABEL org.exegol.tag="${TAG}"
LABEL org.exegol.version="${VERSION}"
LABEL org.exegol.build_date="${BUILD_DATE}"
LABEL org.exegol.app="ExegolFull"
LABEL org.exegol.src_repository="https://github.com/ThePorgs/Exegol-images"

COPY sources /root/sources/
WORKDIR /root/sources/install
RUN echo "${TAG}-${VERSION}" > /opt/.exegol_version
RUN chmod +x entrypoint.sh

RUN chmod +x ../assets/exegol/import_tools.sh

# IOT package

RUN ./entrypoint.sh install_iot_apt_tools

# Misc package

RUN ./entrypoint.sh install_misc_apt_tools
COPY --from=misc /tmp/resources/ /tmp/resources
RUN ../assets/exegol/import_tools.sh
RUN ./entrypoint.sh configure_misc

# Cloud package

RUN ./entrypoint.sh install_cloud_apt_tools
COPY --from=cloud /tmp/resources/ /tmp/resources
RUN ../assets/exegol/import_tools.sh
RUN ./entrypoint.sh configure_cloud

# Latest sync

RUN chmod +x ../assets/exegol/pipx_symlink.sh
RUN ../assets/exegol/pipx_symlink.sh

WORKDIR /root

ENTRYPOINT [ "/.exegol/entrypoint.sh" ]
