#!/bin/bash
# Author: The Exegol Project

source common.sh

function install_c2_apt_tools() {
    # CODE-CHECK-WHITELIST=add-aliases,add-history,add-test-command,add-to-list
    colorecho "Nothing to install"
}

function install_pwncat() {
    # CODE-CHECK-WHITELIST=add-aliases
    colorecho "Installing pwncat"
    python3 -m pipx install pwncat-cs
    add-history pwncat
    add-test-command "pwncat-cs --version"
    add-to-list "pwncat,https://github.com/calebstewart/pwncat,A lightweight and versatile netcat alternative that includes various additional features."
}

function install_metasploit() {
    # CODE-CHECK-WHITELIST=add-aliases
    colorecho "Installing Metasploit"
    fapt libpcap-dev libpq-dev zlib1g-dev libsqlite3-dev
    mkdir /tmp/metasploit_install
    cd /tmp/metasploit_install
    curl https://raw.githubusercontent.com/rapid7/metasploit-omnibus/master/config/templates/metasploit-framework-wrappers/msfupdate.erb -o msfinstall
    chmod +x msfinstall
    rvm use 3.0.0@metasploit --create
    ./msfinstall
    cd /tmp
    rm -rf /tmp/metasploit_install
    mv /opt/metasploit-framework /opt/tools/
    bundle install --gemfile /opt/tools/metasploit-framework/embedded/framework/Gemfile
    rvm use 3.0.0@default
    # https://github.com/ruby/fileutils/issues/22 -> Warnings
    add-history msfconsole
    add-test-command "msfconsole --help"
    add-test-command "msfvenom --help|&grep 'Metasploit standalone payload generator'"
    add-to-list "metasploit,https://github.com/rapid7/metasploit-framework,A popular penetration testing framework that includes many exploits and payloads"
}

function configure_metasploit() {
    colorecho "Configuring Metasploit"
    fapt libjemalloc-dev
    cd /opt/tools/metasploit-framework
    sed -i "s#/opt/metasploit-framework#/opt/tools/metasploit-framework#" bin/*
    ln -v -s /opt/tools/metasploit-framework/bin/msfconsole /opt/tools/bin/msfconsole
    ln -v -s /opt/tools/metasploit-framework/bin/msfvenom /opt/tools/bin/msfvenom
}

function install_routersploit() {
    colorecho "Installing RouterSploit"
    python3 -m pipx install routersploit
    python3 -m pipx inject routersploit colorama
    add-aliases routersploit
    add-history routersploit
    add-test-command "which rsf.py"
    add-to-list "routersploit,https://github.com/threat9/routersploit,Security audit tool for routers."
}

function install_sliver() {
    # CODE-CHECK-WHITELIST=add-aliases
    colorecho "Installing Sliver"
    git -C /opt/tools/ clone --depth 1 https://github.com/BishopFox/sliver.git
    cd /opt/tools/sliver
    make
    mv sliver-* /opt/tools/bin
    add-history sliver
    add-test-command "sliver-server help"
    add-test-command "sliver-client help"
    add-to-list "sliver,https://github.com/BishopFox/sliver.git,Open source / cross-platform and extensible C2 framework"
}

function configure_c2() {
    configure_metasploit
    ln -v -s /root/.local/pipx/venvs/routersploit/bin/rsf.py /root/.local/bin/rsf.py
}

# Package dedicated to command & control frameworks
function package_c2() {
    set_go_env
    set_ruby_env
    # install_empire                # Exploit framework FIXME
    # install_starkiller            # GUI for Empire, commenting while Empire install is not fixed
    install_pwncat                  # netcat and rlwrap on steroids to handle revshells, automates a few things too
    install_metasploit              # Offensive framework
    install_routersploit            # Exploitation Framework for Embedded Devices
    install_sliver                  # Sliver is an open source cross-platform adversary emulation/red team framework
}