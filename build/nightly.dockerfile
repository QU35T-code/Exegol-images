FROM exegol-iot:PR1-arm64 as iot
FROM exegol-misc:PR1-arm64 as misc
FROM exegol-cloud:PR1-arm64 as cloud
FROM exegol-mobile:PR1-arm64 as mobile
FROM exegol-c2:PR1-arm64 as c2
FROM exegol-crypto:PR1-arm64 as crypto
FROM exegol-voip:PR1-arm64 as voip
FROM exegol-wifi:PR1-arm64 as wifi

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
COPY --from=iot /tmp/resources/ /tmp/resources
RUN ../assets/exegol/import_tools.sh
RUN ./entrypoint.sh configure_iot

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

# Mobile package

RUN ./entrypoint.sh install_mobile_apt_tools
COPY --from=mobile /tmp/resources/ /tmp/resources
RUN ../assets/exegol/import_tools.sh
RUN ./entrypoint.sh configure_mobile

# C2 package
RUN ./entrypoint.sh install_c2_apt_tools
COPY --from=c2 /tmp/resources/ /tmp/resources
RUN ../assets/exegol/import_tools.sh
RUN ./entrypoint.sh configure_c2

# Crypto package
RUN ./entrypoint.sh install_crypto_apt_tools
COPY --from=crypto /tmp/resources/ /tmp/resources
RUN ../assets/exegol/import_tools.sh
RUN ./entrypoint.sh configure_crypto

# Voip package
RUN ./entrypoint.sh install_voip_apt_tools
COPY --from=voip /tmp/resources/ /tmp/resources
RUN ../assets/exegol/import_tools.sh
RUN ./entrypoint.sh configure_voip

# Wifi package
RUN ./entrypoint.sh install_wifi_apt_tools
COPY --from=wifi /tmp/resources/ /tmp/resources
RUN ../assets/exegol/import_tools.sh
RUN ./entrypoint.sh configure_wifi

# Latest sync

RUN chmod +x ../assets/exegol/pipx_symlink.sh
RUN ../assets/exegol/pipx_symlink.sh

WORKDIR /root

ENTRYPOINT [ "/.exegol/entrypoint.sh" ]
