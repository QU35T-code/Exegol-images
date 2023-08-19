FROM exegol-iot:PR1-arm64 as iot
FROM exegol-misc:PR1-arm64 as misc
FROM exegol-cloud:PR1-arm64 as cloud

# TODO: add pipx symlink /root/.local/pipx/bin ?

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

# IOT package

RUN ./entrypoint.sh install_iot_apt_tools

# Misc package

RUN ./entrypoint.sh install_misc_apt_tools

COPY --from=misc /tmp/folder-opt /opt/tools/
COPY --from=misc /tmp/folder-ruby /usr/local/rvm/gems/
COPY --from=misc /tmp/folder-go /root/go/bin/
COPY --from=misc /tmp/folder-pipx /root/.local/pipx/venvs/

COPY --from=misc /tmp/aliases-file /opt/.exegol_aliases
COPY --from=misc /tmp/history-file /root/.zsh_history
COPY --from=misc /tmp/test-commands-file /.exegol/build_pipeline_tests/all_commands.txt
COPY --from=misc /tmp/tools-file /.exegol/installed_tools.csv

RUN ./entrypoint.sh configure_searchsploit
RUN ./entrypoint.sh configure_trilium

# Cloud package

# RUN ./entrypoint.sh install_cloud_apt_tools

COPY --from=cloud /tmp/folder-opt /opt/tools/
# COPY --from=cloud /tmp/folder-ruby /usr/local/rvm/gems/
# COPY --from=cloud /tmp/folder-go /root/go/bin/
COPY --from=cloud /tmp/folder-pipx /root/.local/pipx/venvs/

COPY --from=cloud /tmp/aliases-file /opt/.exegol_aliases
COPY --from=cloud /tmp/history-file /root/.zsh_history
COPY --from=cloud /tmp/test-commands-file /.exegol/build_pipeline_tests/all_commands.txt
COPY --from=cloud /tmp/tools-file /.exegol/installed_tools.csv

RUN ./entrypoint.sh configure_kubectl

# Other packages

WORKDIR /root

ENTRYPOINT [ "/.exegol/entrypoint.sh" ]