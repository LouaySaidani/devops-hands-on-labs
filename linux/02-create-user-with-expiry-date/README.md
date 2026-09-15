# Linux Challenge 02 — Create a User with an Expiry Date

## Task

The system administration team at **xFusionCorp Industries** needs to provide temporary access to a developer working on the **Nautilus** project.

The developer named `jim` requires access for a limited period of time. To ensure proper access management, a temporary Linux user account must be created with a specific expiration date.

The requirement is to create the user `jim` on **App Server 3** and configure the account to expire on:

```text
2027-02-17
```

The username must be created in lowercase according to the standard naming convention.

### Requirements

- **Server:** App Server 3
- **Hostname:** `stapp03`
- **Username:** `jim`
- **Project:** Nautilus
- **Account Type:** Temporary user account
- **Expiry Date:** `2027-02-17`
- **Username Format:** Lowercase

---

## Key Concepts

### 1. What is a Linux User Account?

A Linux user account represents an identity that can be used to access and interact with a Linux system.

A user account contains information such as:

- Username
- User ID (UID)
- Primary group
- Home directory
- Login shell
- Password information
- Account expiration information

For example:

```text
jim:x:1001:1001::/home/jim:/bin/bash
```

The account can then be used to authenticate and access resources according to its permissions.

---

### 2. What is an Account Expiry Date?

An **account expiry date** defines the date after which a Linux user account can no longer be used for normal authentication.

For example:

```text
2027-02-17
```

means that the account is intended to be valid only until that date.

This is useful for:

- Temporary employees
- Developers working on temporary projects
- Contractors
- Interns
- External users
- Temporary administrative access
- Project-based accounts

Instead of manually remembering to remove the account later, an expiration date provides an automatic access-control mechanism.

---

### 3. Account Expiration vs Password Expiration

These two concepts are different.

#### Account Expiration

Account expiration controls whether the **user account itself** is still valid.

Example:

```text
2027-02-17
```

After the expiration date, the account is considered expired.

#### Password Expiration

Password expiration controls how long the **user's password** remains valid.

For example, a password could be configured to expire after a certain number of days.

Therefore:

```text
Account expiration ≠ Password expiration
```

In this challenge, we are configuring the **account expiration date**, not the password expiration policy.

---

### 4. The `useradd` Command

`useradd` is a Linux command used to create a new user account.

Basic syntax:

```bash
useradd username
```

For example:

```bash
sudo useradd jim
```

creates a user named `jim`.

The command also supports options for configuring different account properties.

One of these options is:

```text
-e
```

or:

```text
--expiredate
```

which specifies the account expiration date.

---

### 5. The `--expiredate` Option

The `--expiredate` option allows us to specify when the account should expire.

For example:

```bash
sudo useradd --expiredate 2027-02-17 jim
```

This creates the user `jim` and sets the account expiration date to:

```text
2027-02-17
```

The short version is:

```bash
sudo useradd -e 2027-02-17 jim
```

Both commands achieve the same result.

I prefer the long form in documentation because:

```text
--expiredate
```

makes the purpose of the option easier to understand.

---

## Why Use an Expiration Date?

Temporary access should not remain active indefinitely.

Imagine a developer needs access to a server for a project that ends after several months.

Without an expiration date, an administrator would need to remember to manually disable or remove the account.

With:

```text
--expiredate 2027-02-17
```

the account has a defined lifetime.

This follows the principle of:

> **Least privilege and limited access duration**

Users should have access for the time they actually need it rather than indefinitely.

---

## Solution

### Step 1 — Connect to App Server 3

Connect to **App Server 3** using SSH:

```bash
ssh banner@stapp03
```

After connecting, verify the hostname:

```bash
hostname
```

Expected output:

```text
stapp03
```

This confirms that we are working on **App Server 3**.

---

### Step 2 — Create the User with an Expiry Date

Create the user `jim` and set the expiration date to `2027-02-17`:

```bash
sudo useradd --expiredate 2027-02-17 jim
```

The shorter equivalent is:

```bash
sudo useradd -e 2027-02-17 jim
```

### Understanding the Command

```text
sudo
```

Runs the command with administrative privileges.

```text
useradd
```

Creates a new Linux user account.

```text
--expiredate 2027-02-17
```

Sets the account expiration date.

```text
jim
```

Specifies the username.

Therefore:

```bash
sudo useradd --expiredate 2027-02-17 jim
```

means:

> Create a Linux user named `jim` whose account expires on February 17, 2027.

---

## Verification

After creating the account, it is important to verify that the expiration date was correctly configured.

### Use `chage`

The `chage` command is used to view and modify password and account aging information.

Run:

```bash
sudo chage -l jim
```

The important line is:

```text
Account expires                                         : Feb 17, 2027
```

This confirms that the account has an expiration date.

---

## Security Considerations

Temporary accounts should have an explicit expiration date whenever possible.

This helps reduce the risk of forgotten accounts remaining active indefinitely.

For production environments, account expiration should be combined with other security controls such as:

- Least-privilege permissions
- Strong authentication
- SSH key management
- Restricted `sudo` access
- Appropriate group membership
- Access monitoring
- Logging and auditing
- Regular account reviews
- Removing accounts that are no longer required

An expiration date is useful, but it should not be considered a complete security solution by itself.

---

## What I Learned

Through this challenge, I practiced:

- Linux user creation
- `useradd`
- Temporary user accounts
- Account expiration
- `--expiredate`
- `chage`
- Account aging
- `/etc/passwd`
- `/etc/shadow`
- SSH remote administration
- Access lifecycle management
- Least privilege

### Key Commands

Connect to the server:

```bash
ssh <username>@<server>
```

Create a user with an expiration date:

```bash
sudo useradd --expiredate 2027-02-17 jim
```

Short version:

```bash
sudo useradd -e 2027-02-17 jim
```

Set the expiration date after creation:

```bash
sudo chage -E 2027-02-17 jim
```

Check account aging information:

```bash
sudo chage -l jim
```

Check whether the user exists:

```bash
getent passwd jim
```

Search for the user:

```bash
grep '^jim:' /etc/passwd
```

---

## Result

The user `jim` was successfully created on **App Server 3** with the account expiration date configured to:

```text
2027-02-17
```

The final configuration can be verified with:

```bash
sudo chage -l jim
```

The expected result contains:

```text
Account expires : Feb 17, 2027
```

This ensures that `jim` has temporary access to the **Nautilus** project server rather than an account intended to remain valid indefinitely.
