#!/bin/bash
# Author: The Exegol Project

source common.sh

function install_cloud_apt_tools() {
    # CODE-CHECK-WHITELIST=add-aliases,add-history,add-test-command,add-to-list
    colorecho "Nothing to install"
}

function install_kubectl() {
    # CODE-CHECK-WHITELIST=add-aliases
    colorecho "Installing kubectl"
    cd /tmp
    if [[ $(uname -m) = 'x86_64' ]]
    then
        curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
    elif [[ $(uname -m) = 'aarch64' ]]
    then
        curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/arm64/kubectl"
    elif [[ $(uname -m) = 'armv7l' ]]
    then
        curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/arm/kubectl"
    else
        criticalecho-noexit "This installation function doesn't support architecture $(uname -m)" && return
    fi
    install -o root -g root -m 0755 kubectl /opt/tools/bin/kubectl
    rm ./kubectl
    add-history kubectl
    add-test-command "kubectl --help"
    add-to-list "kubectl,https://kubernetes.io/docs/reference/kubectl/overview/,Command-line interface for managing Kubernetes clusters."
}

function install_awscli() {
    # CODE-CHECK-WHITELIST=add-aliases
    colorecho "Installing aws cli"
    cd /tmp
    if [[ $(uname -m) = 'x86_64' ]]
    then
        curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
    elif [[ $(uname -m) = 'aarch64' ]]
    then
        curl "https://awscli.amazonaws.com/awscli-exe-linux-aarch64.zip" -o "awscliv2.zip"
    else
        criticalecho-noexit "This installation function doesn't support architecture $(uname -m)" && return
    fi
    unzip awscliv2.zip
    ./aws/install -i /opt/tools/aws-cli -b /opt/tools/bin
    rm -rf aws awscliv2.zip
    # TODO: improve history : https://www.bluematador.com/learn/aws-cli-cheatsheet
    add-history aws
    add-test-command "aws --version"
    add-to-list "awscli,https://aws.amazon.com/cli/,Command-line interface for Amazon Web Services."
}

function install_scout() {
    # CODE-CHECK-WHITELIST=add-aliases
    colorecho "Installing ScoutSuite"
    python3 -m pipx install scoutsuite
    add-history scout
    add-test-command "scout --help"
    add-to-list "scout,https://github.com/nccgroup/ScoutSuite,Scout Suite is an open source multi-cloud security-auditing tool which enables security posture assessment of cloud environments."
}

function install_cloudsplaining() {
    # CODE-CHECK-WHITELIST=add-aliases
    colorecho "Installing Cloudsplaining"
    python3 -m pipx install cloudsplaining
    add-history cloudsplaining
    add-test-command "cloudsplaining --help"
    add-to-list "cloudsplaining,https://github.com/salesforce/cloudsplaining,AWS IAM Security Assessment tool that identifies violations of least privilege and generates a risk-prioritized report."
}

function install_cloudsploit() {
    colorecho "Installing Cloudsploit"
    git -C /opt/tools/ clone --depth 1 https://github.com/aquasecurity/cloudsploit
    cd /opt/tools/cloudsploit && npm install && chmod +x index.js
    add-aliases cloudsploit
    add-history cloudsploit
    add-test-command "cloudsploit -h"
    add-to-list "cloudsploit,https://github.com/aquasecurity/cloudsploit,Cloud Security Posture Management"
}

function install_prowler() {
    # CODE-CHECK-WHITELIST=add-aliases
    colorecho "Installing Prowler"
    python3 -m pipx install prowler
    add-history prowler
    add-test-command "prowler -h"
    add-to-list "prowler,https://github.com/prowler-cloud/prowler,Perform Cloud Security best practices assessments / audits / incident response / compliance / continuous monitoring / hardening and forensics readiness."
}

function install_cloudmapper() {
    colorecho "Installing Cloudmapper"
    git -C /opt/tools clone --depth 1 https://github.com/duo-labs/cloudmapper.git
    cd /opt/tools/cloudmapper
    python3 -m venv ./venv
    ./venv/bin/python3 -m pip install wheel
    ./venv/bin/python3 -m pip install -r requirements.txt
    add-aliases cloudmapper
    add-history cloudmapper
    add-test-command 'cloudmapper --help |& grep "usage"'
    add-to-list "cloudmapper,https://github.com/duo-labs/cloudmapper,CloudMapper helps you analyze your Amazon Web Services (AWS) environments."
}

function configure_cloud() {
    colorecho "Nothing here"
}

# Package dedicated to cloud tools
function package_cloud() {
    set_ruby_env
    install_kubectl
    install_awscli
    install_scout       # Multi-Cloud Security Auditing Tool
    install_cloudsplaining
    install_cloudsploit
    install_prowler
    install_cloudmapper
}
