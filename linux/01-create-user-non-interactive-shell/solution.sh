```bash
#!/bin/bash
# Connect to App Server 3 using SSH
ssh banner@stapp03
# Create the user "john" with a non-interactive shell
sudo useradd --shell /sbin/nologin john
# Verify the user's account configuration
cat /etc/passwd
```
