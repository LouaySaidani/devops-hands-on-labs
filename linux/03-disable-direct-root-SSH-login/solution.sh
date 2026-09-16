#!/bin/bash

sudo sed -i -E 's/^[#[:space:]]*PermitRootLogin[[:space:]].*/PermitRootLogin no/' /etc/ssh/sshd_config

sudo sshd -t
sudo systemctl restart sshd

sudo sshd -T | grep -i permitrootlogin