# Linux Challenge 01 — Create a User with a Non-Interactive Shell

## Task

The system administration team at **xFusionCorp Industries** needs a user for a backup agent tool.

The requirement is to create a user named `john` on **App Server 3** and configure the account with a **non-interactive shell**.

### Requirements

- **Server:** App Server 3
- **Username:** `john`
- **Shell:** Non-interactive
- **Purpose:** Backup agent

---

## Key Concepts

### 1. What is a Shell?

A **shell** is a program that provides an interface between a user and the operating system.

When we enter a command such as:

```bash
ls
```

the shell interprets the command and asks the operating system to execute it.

Common Linux shells include:

- `bash`
- `sh`
- `zsh`
- `fish`

---

### 2. Interactive vs Non-Interactive Shell

#### Interactive Shell

An **interactive shell** allows a user to directly enter commands and receive output.

For example:

```bash
bash
```

opens a Bash shell where we can type commands:

```bash
whoami
pwd
ls
```

This type of shell is useful when a human needs to work directly with the system.

#### Non-Interactive Shell

A **non-interactive shell** does not provide a normal command prompt for a user to interact with.

It is commonly used for:

- Service accounts
- Automated processes
- Backup agents
- Application accounts
- Accounts that should not be used for normal login

A common configuration is:

```text
/sbin/nologin
```

This prevents the account from being used as a normal interactive login account.

> **Important:** A non-interactive shell does not mean that the user cannot exist or perform any actions. It mainly prevents the account from obtaining a normal interactive shell session.

---

## Why Use a Non-Interactive Shell?

Service accounts often don't need human access.

For example, imagine a backup agent running as:

```text
backup-agent
```

There is usually no reason for a person to log in interactively as this account.

Using:

```text
/sbin/nologin
```

reduces unnecessary interactive access and follows the principle of **least privilege**.

---

## What is SSH?

**SSH (Secure Shell)** is a protocol used to securely access and administer remote systems.

For example:

```bash
ssh user@server
```

allows an administrator to establish a remote session with a server.

SSH commonly uses **TCP port 22** and provides encrypted communication.

In this challenge, SSH is useful because we first need to connect to **App Server 3** before creating the user.

---

## Solution

### Step 1 — Connect to App Server 3

Connect to **App Server 3** using SSH:

```bash
ssh banner@stapp03
```

After connecting, we are working directly on `stapp03`.

---

### Step 2 — Create the User

Create the user `john` with `/sbin/nologin` as the login shell:

```bash
sudo useradd --shell /sbin/nologin john
```

The shorter equivalent is:

```bash
sudo useradd -s /sbin/nologin john
```

### Understanding the Command

```text
sudo
```

Runs the command with administrative privileges.

```text
useradd
```

Creates a new Linux user.

```text
--shell /sbin/nologin
```

Sets the user's login shell to `/sbin/nologin`.

```text
john
```

The username being created.

---

## Verification

### Method 1 — Check `/etc/passwd`

Linux stores basic user account information in `/etc/passwd`.

We can display the file with:

```bash
cat /etc/passwd
```

Look for the `john` entry:

```text
john:x:1001:1001::/home/john:/sbin/nologin
```

The last field:

```text
/sbin/nologin
```

confirms that `john` has a non-interactive login shell.

### Method 2 — Search specifically for `john`

Instead of displaying the entire file, we can search directly for the user:

```bash
grep '^john:' /etc/passwd
```

Expected output:

```text
john:x:1001:1001::/home/john:/sbin/nologin
```

This is generally more convenient when `/etc/passwd` contains many users.

---

## Optional Test

We can also test whether `john` can obtain an interactive shell:

```bash
sudo su - john
```

Because the account uses `/sbin/nologin`, the interactive login should be refused.

The exact message may vary depending on the Linux distribution.

---

## Alternative Approach

The shell can also be specified using the short option:

```bash
sudo useradd -s /sbin/nologin john
```

Both commands achieve the same configuration:

```bash
sudo useradd --shell /sbin/nologin john
```

```bash
sudo useradd -s /sbin/nologin john
```

I prefer the long form in documentation because `--shell` makes the purpose of the option immediately clear.

---

## Security Recommendation

For accounts used by services or automation, avoid giving them an interactive shell unless it is actually required.

A dedicated service account with a non-interactive shell can help reduce unnecessary interactive access.

However, **a non-interactive shell alone is not a complete security control**.

For production systems, also consider:

- Least-privilege permissions
- Appropriate file ownership
- Restricted `sudo` access
- SSH access controls
- Strong authentication
- Service-specific permissions
- Monitoring and auditing

---

## What I Learned

Through this challenge, I practiced:

- Linux user creation
- `useradd`
- Linux login shells
- Interactive vs non-interactive shells
- `/sbin/nologin`
- SSH remote administration
- Basic account verification
- The principle of least privilege

### Key Commands

```bash
ssh <username>@<server>
```

```bash
sudo useradd --shell /sbin/nologin john
```

```bash
getent passwd john
```

```bash
grep '^john:' /etc/passwd
```

---

## Result

The user `john` was successfully created on **App Server 3** with `/sbin/nologin` configured as the login shell.

This prevents the account from being used as a normal interactive login account while allowing it to exist as a dedicated account for the required system purpose.
