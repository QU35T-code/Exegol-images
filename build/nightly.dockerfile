# Author: The Exegol Project

ARG TAG
ARG ARCH

FROM exegol-iot:${TAG}-${ARCH} as iot
FROM exegol-misc:${TAG}-${ARCH} as misc
FROM exegol-cloud:${TAG}-${ARCH} as cloud
FROM exegol-mobile:${TAG}-${ARCH} as mobile
FROM exegol-c2:${TAG}-${ARCH} as c2
FROM exegol-crypto:${TAG}-${ARCH} as crypto
FROM exegol-voip:${TAG}-${ARCH} as voip
FROM exegol-wifi:${TAG}-${ARCH} as wifi
FROM exegol-forensic:${TAG}-${ARCH} as forensic
FROM exegol-code_analysis:${TAG}-${ARCH} as code_analysis
FROM exegol-wordlists:${TAG}-${ARCH} as wordlists
FROM exegol-cracking:${TAG}-${ARCH} as cracking
FROM exegol-rfid:${TAG}-${ARCH} as rfid
FROM exegol-sdr:${TAG}-${ARCH} as sdr
FROM exegol-ad:${TAG}-${ARCH} as ad

FROM exegol-base:${TAG}-${ARCH}

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

# Forensic package
RUN ./entrypoint.sh install_forensic_apt_tools
COPY --from=forensic /tmp/resources/ /tmp/resources
RUN ../assets/exegol/import_tools.sh
RUN ./entrypoint.sh configure_forensic

# Code analysis package
RUN ./entrypoint.sh install_code_analysis_apt_tools
COPY --from=code_analysis /tmp/resources/ /tmp/resources
RUN ../assets/exegol/import_tools.sh
RUN ./entrypoint.sh configure_code_analysis

# Wordlists package
RUN ./entrypoint.sh install_wordlists_apt_tools
COPY --from=wordlists /tmp/resources/ /tmp/resources
RUN ../assets/exegol/import_tools.sh
RUN ./entrypoint.sh configure_wordlists

# Cracking package
RUN ./entrypoint.sh install_cracking_apt_tools
COPY --from=cracking /tmp/resources/ /tmp/resources
RUN ../assets/exegol/import_tools.sh
RUN ./entrypoint.sh configure_cracking

# RFID package
RUN ./entrypoint.sh install_rfid_apt_tools
COPY --from=rfid /tmp/resources/ /tmp/resources
RUN ../assets/exegol/import_tools.sh
RUN ./entrypoint.sh configure_rfid

# SDR package
RUN ./entrypoint.sh install_sdr_apt_tools
COPY --from=sdr /tmp/resources/ /tmp/resources
RUN ../assets/exegol/import_tools.sh
RUN ./entrypoint.sh configure_sdr

# AD package
RUN ./entrypoint.sh install_ad_apt_tools
COPY --from=ad /tmp/resources/ /tmp/resources
RUN ../assets/exegol/import_tools.sh
RUN ./entrypoint.sh configure_ad

WORKDIR /root

ENTRYPOINT [ "/.exegol/entrypoint.sh" ]
