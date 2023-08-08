#!/bin/bash
# Author: The Exegol Project

source common.sh

function install_test_apt_tools() {
    fapt steghide
}

function install_python_tool() {
    colorecho "Installing Python tool"
    git -C /opt/tools/ clone --depth 1 https://github.com/GerbenJavado/LinkFinder.git
    cd /opt/tools/LinkFinder
    python3 -m venv ./venv
    ./venv/bin/python3 -m pip install -r requirements.txt
    add-aliases linkfinder
    add-history linkfinder
    add-test-command "linkfinder --help"
    add-to-list "linkfinder,https://github.com/GerbenJavado/LinkFinder,a Python script that finds endpoints and their parameters in JavaScript files."
}
    
function install_ruby_tool() {
    colorecho "Installing Ruby tool"
    rvm use 3.0.0@haiti --create
    gem install haiti-hash
    rvm use 3.0.0@default
    add-aliases haiti
    add-history haiti
    add-test-command "haiti --help"
    add-to-list "haiti,https://github.com/noraj/haiti,haiti is a A CLI tool (and library) to identify hash types (hash type identifier)."
}

function install_rust_tool() {
    colorecho "Installing rust tool"
}

function install_go_tool() {
    colorecho "Installing go tool"
    go install -v github.com/projectdiscovery/dnsx/cmd/dnsx@latest
    add-history dnsx
    add-test-command "dnsx --help"
    add-to-list "dnsx,https://github.com/projectdiscovery/dnsx,A tool for DNS reconnaissance that can help identify subdomains and other related domains."
}

function install_pipx_tool() {
    colorecho "Installing pipx tool"
    python3 -m pipx install semgrep
    add-history semgrep
    add-test-command "semgrep --help"
    add-to-list "semgrep,https://github.com/returntocorp/semgrep/,Static analysis tool that supports multiple languages and can find a variety of vulnerabilities and coding errors."
}

function package_test() {
    set_go_env
    set_ruby_env
    install_test_apt_tools
    install_python_tool
    install_ruby_tool
    install_rust_tool
    install_go_tool
    install_pipx_tool
}
