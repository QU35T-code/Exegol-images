#!/bin/bash

echo "Extract tools"
mkdir /tmp/resources

cp -r /opt/tools/ /tmp/resources/folder-opt/
cp -r /usr/local/rvm/gems/ /tmp/resources/folder-ruby/
cp -r /root/go/bin/ /tmp/resources/folder-go/
cp -r /root/.local/pipx/venvs/ /tmp/resources/folder-pipx/

cp /opt/.exegol_aliases /tmp/resources/aliases-file
cp /root/.zsh_history /tmp/resources/history-file
cp /.exegol/build_pipeline_tests/all_commands.txt /tmp/resources/test-commands-file
cp /.exegol/installed_tools.csv /tmp/resources/tools-file