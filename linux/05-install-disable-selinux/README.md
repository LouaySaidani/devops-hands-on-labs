# Linux Challenge 05 — Install and Permanently Disable SELinux

## Task

Following a security audit, the `xFusionCorp Industries` security team has decided to enhance application and server security using **SELinux**.

To initiate testing, the following requirements were established for **App Server 1** in the **Stratos Datacenter**:

1. Install the required SELinux packages.
2. Permanently disable SELinux for the time being. It will be re-enabled after the necessary configuration changes.
3. No need to reboot the server, as a scheduled maintenance reboot is already planned for tonight.
4. Disregard the current SELinux status via the command line; the final status after the reboot should be `disabled`.

---

## Requirements

- Server: **App Server 1**
- Hostname: `stapp01`
- User: `tony`
- SELinux configuration file: `/etc/selinux/config`
- Required final configuration:

```ini
SELINUX=disabled
```

- No reboot required.

---

# Key Concepts

## 1. What is SELinux?

**SELinux** stands for **Security-Enhanced Linux**.

It is a Linux security mechanism that provides an additional layer of access control.

Traditional Linux permissions use:

```text
Owner
Group
Others
```

with permissions such as:

```text
r = read
w = write
x = execute
```

SELinux adds another security layer based on **security policies and contexts**.

For example, even if a Linux user has permission to access a file, SELinux can potentially restrict that access according to its security policy.

---

## 2. SELinux Modes

SELinux can operate in different modes.

### Enforcing

```text
Enforcing
```

SELinux actively enforces its security policies and blocks unauthorized actions.

### Permissive

```text
Permissive
```

SELinux logs policy violations but does not block them.

### Disabled

```text
Disabled
```

SELinux is completely disabled.

For this challenge, the required final state is:

```text
disabled
```

---

## 3. SELinux Configuration File

The main configuration file used in this challenge is:

```text
/etc/selinux/config
```

The setting:

```ini
SELINUX=disabled
```

specifies that SELinux should be disabled.

This is different from simply changing the current runtime state.

The challenge specifically asks for a **permanent** configuration because the server will be rebooted later.

---

# Solution

## Step 1 — Connect to App Server 1

From the jump host:

```bash
ssh tony@stapp01
```

---

## Step 2 — Install the Required SELinux Packages

Run:

```bash
sudo yum install -y policycoreutils selinux-policy selinux-policy-targeted
```

The installation completed successfully.

The installed SELinux-related packages included:

```text
selinux-policy
selinux-policy-targeted
policycoreutils
```

as well as their required dependencies.

The package manager reported:

```text
Complete!
```

---

## Step 3 — Check the Current SELinux Status

You can check the current status with:

```bash
sestatus
```

In this environment, the output was:

```text
SELinux status:                 disabled
```

However, the challenge explicitly says to **disregard the current command-line status**.

The important requirement is to configure the system so that SELinux will be disabled after the planned reboot.

---

## Step 4 — Edit the SELinux Configuration

Open the configuration file:

```bash
sudo nano /etc/selinux/config
```

Find:

```ini
SELINUX=
```

and set it to:

```ini
SELINUX=disabled
```

The final configuration should therefore contain:

```ini
SELINUX=disabled
```

Save the file and exit.

---

# Verification

### Check Current Status

You can also run:

```bash
sestatus
```

In this environment, it returned:

```text
SELinux status:                 disabled
```

However, the important verification for this challenge is:

```text
/etc/selinux/config
        ↓
SELINUX=disabled
```

because the task specifically requires the **final state after reboot** to be disabled.

---

# Important: Why No Reboot?

Normally, changing the SELinux configuration may require a reboot for the new state to fully take effect.

However, the challenge explicitly states that a maintenance reboot is already scheduled.

Therefore, we should **not reboot the server manually**.

The required configuration is simply:

```ini
SELINUX=disabled
```

and the scheduled reboot will apply the configuration later.

---

# Security Consideration

SELinux provides an additional security layer on Linux systems.

Disabling it removes that additional layer of mandatory access control.

In this challenge, SELinux is being disabled **temporarily** because the security team plans to make configuration changes before re-enabling it.

In a production environment, SELinux should generally not be disabled without a specific operational reason and appropriate security review.

---

# What I Learned

### Key Concepts

- SELinux stands for **Security-Enhanced Linux**.
- SELinux provides an additional security layer beyond traditional Linux permissions.
- SELinux has different modes such as `Enforcing`, `Permissive`, and `Disabled`.
- SELinux configuration is stored in `/etc/selinux/config`.
- `SELINUX=disabled` configures SELinux to be disabled.
- A permanent configuration change is different from changing only the current runtime state.
- `sestatus` can be used to check the current SELinux status.
- `grep` can be used to verify the configuration file.
- `yum install` can be used to install the required SELinux packages.
- A reboot was intentionally not performed because the challenge specifies that one is already scheduled.

---

# Key Commands

### Connect to the server

```bash
ssh tony@stapp01
```

### Install SELinux packages

```bash
sudo yum install -y policycoreutils selinux-policy selinux-policy-targeted
```

### Check SELinux status

```bash
sestatus
```

### Edit SELinux configuration

```bash
sudo nano /etc/selinux/config
```

---

# Result

The required SELinux packages were successfully installed on **App Server 1 (\*\***`stapp01`\***\*)**.

The SELinux configuration was changed to:

```ini
SELINUX=disabled
```

No reboot was performed, as requested by the task.

The server is therefore configured so that after the scheduled reboot, the final SELinux status will be:

```text
disabled
```

**Challenge completed successfully.**
