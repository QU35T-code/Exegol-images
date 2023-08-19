#!/bin/bash

echo "Import tools"

cp -r /tmp/resources/folder-opt/* /opt/tools/
cp -r /tmp/resources/folder-ruby/* /usr/local/rvm/gems/
cp -r /tmp/resources/folder-go/* /root/go/bin/
cp -r /tmp/resources/folder-pipx/* /root/.local/pipx/venvs/

cat /tmp/resources/aliases-file >> /opt/.exegol_aliases
cat /tmp/resources/history-file >> /root/.zsh_history
cat /tmp/resources/test-commands-file >> /.exegol/build_pipeline_tests/all_commands.txt
cat /tmp/resources/tools-file >> /.exegol/installed_tools.csv