#!/bin/bash

# Create the temporary user "jim"
# with an account expiration date of 2027-02-17

sudo useradd --expiredate 2027-02-17 jim

# Verify the account configuration
sudo chage -l jim