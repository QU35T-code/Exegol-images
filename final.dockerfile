FROM exegol-test as test
FROM exegol-iot as iot
FROM exegol-misc as misc

# TODO: add pipx symlink /root/.local/pipx/bin ?

FROM exegol-base

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


# Test package

RUN ./entrypoint.sh install_test_apt_tools

COPY --from=test /tmp/folder-opt /opt/tools/
COPY --from=test /tmp/folder-ruby /usr/local/rvm/gems/
COPY --from=test /tmp/folder-go /root/go/bin/
COPY --from=test /tmp/folder-pipx /root/.local/pipx/venvs/

COPY --from=test /tmp/aliases-file /opt/.exegol_aliases
COPY --from=test /tmp/history-file /root/.zsh_history
COPY --from=test /tmp/test-commands-file /.exegol/build_pipeline_tests/all_commands.txt
COPY --from=test /tmp/tools-file /.exegol/installed_tools.csv

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

# Other packages

WORKDIR /root

ENTRYPOINT [ "/.exegol/entrypoint.sh" ]
