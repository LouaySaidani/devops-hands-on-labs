# Linux Challenge 03 — Disable Direct Root SSH Login

## Task

Following security audits, the security team at **xFusionCorp Industries** has introduced new security protocols for the **Stratos Datacenter**.

One of the new requirements is to prevent users from logging directly into the application servers as the `root` user through SSH.

The task is to disable **direct SSH root login** on all application servers in the Stratos Datacenter.

### Requirements

- **Datacenter:** Stratos Datacenter
- **Servers:** App Server 1, App Server 2, App Server 3
- **Hostnames:**
  - `stapp01`
  - `stapp02`
  - `stapp03`

- **Security requirement:** Disable direct root SSH login
- **SSH configuration:** `PermitRootLogin no`

---

## Key Concepts

### 1. What is SSH?

**SSH (Secure Shell)** is a protocol used to securely connect to remote Linux systems.

For example:

```bash
ssh user@server
```

allows a user to establish a remote shell session on the specified server.

SSH commonly uses TCP port `22` and provides encrypted communication.

In this challenge, SSH is the mechanism that must be configured to prevent direct access using the `root` account.

---

### 2. What is the Root User?

`root` is the superuser account on a Linux system.

The root user has extensive privileges and can perform administrative operations such as:

- Installing software
- Creating and deleting users
- Modifying system configuration
- Managing services
- Accessing protected files
- Changing permissions
- Restarting the system

For example:

```bash
sudo su -
```

can be used by an authorized user to obtain a root shell.

However, allowing direct remote SSH login as `root` creates additional security risks.

---

## Why Disable Direct Root SSH Login?

A common security practice is to prevent direct SSH authentication as `root`.

Instead of:

```bash
ssh root@server
```

administrators should connect using their individual accounts:

```bash
ssh admin@server
```

and then use:

```bash
sudo
```

when administrative privileges are required.

For example:

```bash
ssh tony@stapp01
```

followed by:

```bash
sudo su -
```

This provides a clearer separation between:

```text
User authentication
       ↓
Individual account
       ↓
sudo
       ↓
Administrative privileges
```

This approach also makes administrative activity easier to attribute to a specific user.

---

## 3. The `sshd_config` File

The SSH server configuration is commonly stored in:

```text
/etc/ssh/sshd_config
```

This file controls how the SSH daemon behaves.

One of its configuration directives is:

```text
PermitRootLogin
```

This controls whether the SSH server permits the `root` account to log in directly.

---

## 4. `PermitRootLogin`

The SSH configuration directive:

```text
PermitRootLogin
```

controls direct SSH login for the root account.

For example:

```text
PermitRootLogin yes
```

allows direct root SSH login.

To disable it:

```text
PermitRootLogin no
```

This is the configuration required by this challenge.

---

## Solution

The configuration must be applied to **all three application servers**.

### App Server 1 — `stapp01`

Connect to App Server 1:

```bash
ssh tony@stapp01
```

Obtain administrative privileges:

```bash
sudo su -
```

Edit the SSH server configuration:

```bash
vi /etc/ssh/sshd_config
```

Set:

```text
PermitRootLogin no
```

Save the file.

Restart the SSH service:

```bash
systemctl restart sshd
```

Verify the effective configuration:

```bash
sshd -T | grep permitrootlogin
```

Expected output:

```text
permitrootlogin no
```

---

### App Server 2 — `stapp02`

Connect to App Server 2 using an authorized non-root account:

```bash
ssh steve@stapp02
```

Obtain administrative privileges:

```bash
sudo su -
```

Edit:

```bash
vi /etc/ssh/sshd_config
```

Set:

```text
PermitRootLogin no
```

Then verify the effective SSH configuration:

```bash
sudo sshd -T | grep permitrootlogin
```

Expected output:

```text
permitrootlogin no
```

A direct root SSH attempt should then be rejected.

From the jump host:

```bash
ssh root@stapp02
```

Expected result:

```text
Permission denied
```

This confirms that direct root SSH authentication is no longer permitted.

---

### App Server 3 — `stapp03`

Connect to App Server 3:

```bash
ssh banner@stapp03
```

Obtain administrative privileges:

```bash
sudo su -
```

Edit:

```bash
vi /etc/ssh/sshd_config
```

Set:

```text
PermitRootLogin no
```

Restart SSH:

```bash
systemctl restart sshd
```

Verify:

```bash
sshd -T | grep permitrootlogin
```

Expected output:

```text
permitrootlogin no
```

---

## Understanding the Commands

### `vi /etc/ssh/sshd_config`

```bash
vi /etc/ssh/sshd_config
```

opens the SSH server configuration file for editing.

The file contains configuration directives controlling the behavior of the SSH daemon.

---

### `PermitRootLogin no`

```text
PermitRootLogin no
```

tells the SSH server not to allow direct SSH login as the `root` user.

This does **not** disable the root account itself.

For example, an authorized user may still be able to run:

```bash
sudo su -
```

and obtain a root shell.

The difference is:

```text
Direct SSH root login:

ssh root@stapp01
        ↓
       DENIED


Normal user SSH login:

ssh tony@stapp01
        ↓
      tony
        ↓
sudo su -
        ↓
       root
```

Therefore, the requirement is specifically about **direct SSH root access**.

---

### `systemctl restart sshd`

```bash
systemctl restart sshd
```

restarts the SSH daemon.

This causes the SSH service to reload the configuration.

After changing:

```text
/etc/ssh/sshd_config
```

the SSH service needs to reload or restart for the configuration to take effect.

---

### `sshd -T`

```bash
sshd -T
```

displays the effective SSH server configuration.

This is particularly useful because it shows what `sshd` is actually using after processing its configuration.

To check only the root-login setting:

```bash
sshd -T | grep permitrootlogin
```

Expected:

```text
permitrootlogin no
```

---

## Verification

### Check the Effective SSH Configuration

Run:

```bash
sshd -T | grep permitrootlogin
```

Expected:

```text
permitrootlogin no
```

This is one of the most useful verification methods because it checks the effective SSH configuration rather than simply searching the configuration file.

---

### Method 2 — Test Direct Root SSH Login

From the jump host, attempt:

```bash
ssh root@stapp01
```

The login should fail.

For example:

```text
Permission denied
```

Repeat for:

```bash
ssh root@stapp02
```

and:

```bash
ssh root@stapp03
```

Direct root SSH access should be rejected on all three application servers.

> **Important:** A failed SSH root login alone is not always sufficient proof that `PermitRootLogin no` is configured. Other authentication restrictions could also cause a failure. Therefore, verify the effective configuration with `sshd -T`.

---

## Important Security Consideration

Before restarting SSH after modifying its configuration, it is good practice to validate the configuration.

Run:

```bash
sshd -t
```

If there is no output, the configuration syntax is valid.

A safer workflow is:

```bash
vi /etc/ssh/sshd_config
```

then:

```bash
sshd -t
```

and only after successful validation:

```bash
systemctl restart sshd
```

This reduces the risk of restarting SSH with a syntax error that could prevent the service from starting correctly.

---

## Recommended Workflow

For production systems, a good workflow is:

```text
Edit configuration
       ↓
Validate configuration
       ↓
Restart / reload SSH
       ↓
Check effective configuration
       ↓
Test access
```

In commands:

```bash
vi /etc/ssh/sshd_config
sshd -t
systemctl restart sshd
sshd -T | grep permitrootlogin
```

Expected final result:

```text
permitrootlogin no
```

---

## Why Use Individual Accounts?

Instead of allowing:

```bash
ssh root@server
```

administrators can use their own accounts:

```bash
ssh tony@server
```

and then:

```bash
sudo -i
```

or:

```bash
sudo su -
```

This provides several advantages:

- Individual user identification
- Better auditing
- Controlled administrative privileges
- Easier account management
- Reduced direct exposure of the root account

For example:

```text
ssh tony@stapp01
       ↓
     sudo
       ↓
     root
```

is different from:

```text
ssh root@stapp01
```

The first approach requires authentication as an individual user before administrative privileges are obtained.

---

## Security Recommendation

Disabling direct root SSH login is only one part of SSH hardening.

Production systems should also consider:

- SSH key authentication
- Disabling unnecessary password authentication
- Strong authentication policies
- Least-privilege `sudo` rules
- Restricting SSH access to trusted networks
- Firewall rules
- Account lifecycle management
- SSH logging and monitoring
- Regular security audits
- Configuration validation before restarting SSH

The exact hardening configuration should depend on the organization's operational requirements.

---

## What I Learned

Through this challenge, I practiced:

- SSH administration
- SSH server configuration
- `/etc/ssh/sshd_config`
- `PermitRootLogin`
- `sshd`
- `systemctl`
- SSH security hardening
- Configuration validation
- Effective SSH configuration verification
- Testing SSH authentication
- Root vs `sudo` access
- Least-privilege administration

### Key Commands

Connect to a server:

```bash
ssh <username>@<server>
```

Edit SSH configuration:

```bash
sudo vi /etc/ssh/sshd_config
```

Disable direct root SSH login:

```text
PermitRootLogin no
```

Validate SSH configuration:

```bash
sudo sshd -t
```

Restart SSH:

```bash
sudo systemctl restart sshd
```

Check effective configuration:

```bash
sudo sshd -T | grep permitrootlogin
```

Test root SSH access:

```bash
ssh root@<server>
```

---

## Result

Direct SSH root login was disabled on all three application servers in the **Stratos Datacenter**:

```text
stapp01
stapp02
stapp03
```

The effective SSH configuration was verified using:

```bash
sshd -T | grep permitrootlogin
```

with the expected result:

```text
permitrootlogin no
```

A direct SSH attempt such as:

```bash
ssh root@stapp02
```

was rejected with:

```text
Permission denied
```

Authorized administrators can still connect using their individual accounts and obtain administrative privileges through `sudo` when required.
