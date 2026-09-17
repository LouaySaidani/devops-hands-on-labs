#!/bin/bash

# Install required SELinux packages
sudo yum install -y policycoreutils selinux-policy selinux-policy-targeted

# Permanently disable SELinux
sudo sed -i 's/^SELINUX=.*/SELINUX=disabled/' /etc/selinux/config
