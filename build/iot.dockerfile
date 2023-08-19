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

RUN ./entrypoint.sh package_iot

RUN ./entrypoint.sh post_install

FROM alpine:3.17.2

WORKDIR /tmp

# No IOT installation, skipping...

# COPY --from=build /opt/tools/ folder-opt/
# COPY --from=build /usr/local/rvm/gems/ folder-ruby/
# COPY --from=build /root/go/bin/ folder-go/
# COPY --from=build /root/.local/pipx/venvs/ folder-pipx/

# COPY --from=build /opt/.exegol_aliases aliases-file
# COPY --from=build /root/.zsh_history history-file
# COPY --from=build /.exegol/build_pipeline_tests/all_commands.txt test-commands-file
# COPY --from=build /.exegol/installed_tools.csv tools-file