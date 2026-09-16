# Linux Challenge 04 — Grant Execute Permissions to a Script

## Task

In a bid to automate backup processes, the `xFusionCorp Industries` sysadmin team has developed a new Bash script named `xfusioncorp.sh`.

The script has already been distributed to the required servers, but it does not have executable permissions on **App Server 1** in the **Stratos Datacenter**.

The task is to:

- Grant executable permissions to `/tmp/xfusioncorp.sh`.
- Ensure that **all users** can execute the script.
- Verify that the script can be executed successfully.

---

## Requirements

- Server: **App Server 1**
- Hostname: `stapp01`
- User: `tony`
- Script: `/tmp/xfusioncorp.sh`
- Required permission: users should be able to execute the script.

---

# Key Concepts

## 1. File Permissions in Linux

Linux permissions control what the owner, group, and other users can do with a file.

The three basic permissions are:

```text
r = read
w = write
x = execute
```

They are represented as:

```text
rwx
```

For example:

```text
-rwxr-xr-x
```

This means:

```text
Owner  → rwx
Group  → r-x
Others → r-x
```

---

## 2. Numeric Permissions

Linux also represents permissions using numbers:

```text
r = 4
w = 2
x = 1
```

The values are added together.

For example:

```text
7 = 4 + 2 + 1 = rwx
5 = 4 + 0 + 1 = r-x
4 = 4 + 0 + 0 = r--
```

Therefore:

```text
755 = rwxr-xr-x
```

Which means:

```text
Owner  → rwx
Group  → r-x
Others → r-x
```

---

## 3. What Does `chmod 755` Mean?

The command:

```bash
chmod 755 /tmp/xfusioncorp.sh
```

sets the permissions to:

```text
rwxr-xr-x
```

Therefore:

- The owner can read, write, and execute.
- The group can read and execute.
- Other users can read and execute.

Most importantly for this challenge:

```text
Others → x
```

So **all users can execute the script**.

---

## 4. `chmod +x` vs `chmod 755`

The command:

```bash
chmod +x /tmp/xfusioncorp.sh
```

adds the execute permission.

In this challenge, the file initially had:

```text
----------
```

After running:

```bash
sudo chmod +x /tmp/xfusioncorp.sh
```

the permissions became:

```text
---x--x--x
```

This means all three categories received execute permission:

```text
Owner  → --x
Group  → --x
Others → --x
```

However, the file still does **not have read permission**.

For this challenge, `chmod 755` is a cleaner final permission because it gives:

```text
rwxr-xr-x
```

---

# Solution

## Step 1 — Connect to App Server 1

From the jump host:

```bash
ssh tony@stapp01
```

---

## Step 2 — Check the Script

First, check the current permissions:

```bash
ls -l /tmp/xfusioncorp.sh
```

The original permissions were:

```text
---------- 1 root root 40 Sep 16 18:36 /tmp/xfusioncorp.sh
```

This means the file has **no permissions** for the owner, group, or others.

---

## Step 3 — Grant Execute Permissions

Use `chmod` with `sudo`:

```bash
sudo chmod 755 /tmp/xfusioncorp.sh
```

Why `sudo`?

The file belongs to:

```text
root root
```

Therefore, the normal user `tony` cannot modify its permissions without sufficient privileges.

---

## Step 4 — Verify the Permissions

Run:

```bash
ls -l /tmp/xfusioncorp.sh
```

The expected result is:

```text
-rwxr-xr-x 1 root root 40 Sep 16 18:36 /tmp/xfusioncorp.sh
```

The important part is:

```text
rwxr-xr-x
```

Breaking it down:

```text
Owner  → rwx
Group  → r-x
Others → r-x
```

Therefore, all users have the execute permission.

---

# Step 5 — Execute the Script

The script can now be executed directly:

```bash
/tmp/xfusioncorp.sh
```

You can also execute it using:

```bash
bash /tmp/xfusioncorp.sh
```

Expected output:

```text
Welcome To KodeKloud
```

---

# Important Difference: `bash script.sh` vs `./script.sh`

There are two common ways to run a Bash script.

### Using Bash

```bash
bash /tmp/xfusioncorp.sh
```

Here, the `bash` program reads the script.

### Executing the script directly

```bash
/tmp/xfusioncorp.sh
```

For this to work, the file needs execute permission:

```text
x
```

and normally the script should have a valid shebang, for example:

```bash
#!/bin/bash
```

Therefore, giving the script execute permission allows it to be launched directly.

---

# Why Did `bash /tmp/xfusioncorp.sh` Fail Before `chmod 755`?

Initially the file had:

```text
----------
```

You then ran:

```bash
sudo chmod +x /tmp/xfusioncorp.sh
```

which produced:

```text
---x--x--x
```

However, when you ran:

```bash
bash /tmp/xfusioncorp.sh
```

you still received:

```text
Permission denied
```

This happened because `bash` needs to **read the script file**, not merely execute it.

After:

```bash
sudo chmod 755 /tmp/xfusioncorp.sh
```

the permissions became:

```text
-rwxr-xr-x
```

Now the file is readable and executable, so:

```bash
bash /tmp/xfusioncorp.sh
```

works.

This is an important Linux permissions concept:

```text
x → execute
r → read
```

`x` alone does not necessarily give a user the ability to read the contents of a regular script file.

---

# Verification

Check the permissions:

```bash
ls -l /tmp/xfusioncorp.sh
```

Expected:

```text
-rwxr-xr-x
```

You can also use:

```bash
stat /tmp/xfusioncorp.sh
```

And verify execution:

```bash
/tmp/xfusioncorp.sh
```

Expected:

```text
Welcome To KodeKloud
```

---

# Security Recommendation

Giving execute permission to all users does not mean that all users should be allowed to modify the script.

The recommended permission:

```text
755
```

allows:

```text
Owner  → read/write/execute
Group  → read/execute
Others → read/execute
```

Only the owner has write permission.

This is safer than giving everyone write permission, such as:

```text
777
```

because with `777`, any user could modify the script.

For system scripts, avoid:

```bash
chmod 777 script.sh
```

unless there is a very specific and justified reason.

---

# What I Learned

### Key Concepts

- Linux files have `r`, `w`, and `x` permissions.
- `chmod` changes file permissions.
- `755` means `rwxr-xr-x`.
- `7 = rwx`.
- `5 = r-x`.
- `x` allows execution of a file.
- `r` allows reading a file.
- `chmod +x` adds execute permission.
- `chmod a+x` adds execute permission for all users.
- `sudo` is required when modifying permissions of a file owned by another user such as `root`.
- A script can be executed with `bash script.sh` or directly with `./script.sh`.
- `bash script.sh` requires the script to be readable by the user running Bash.
- `755` allows everyone to execute the script while only the owner can modify it.

---

# Key Commands

### Check permissions

```bash
ls -l /tmp/xfusioncorp.sh
```

### Add execute permission

```bash
sudo chmod +x /tmp/xfusioncorp.sh
```

### Set standard executable permissions

```bash
sudo chmod 755 /tmp/xfusioncorp.sh
```

### Execute with Bash

```bash
bash /tmp/xfusioncorp.sh
```

### Execute directly

```bash
/tmp/xfusioncorp.sh
```

---

# Result

The `/tmp/xfusioncorp.sh` script on **App Server 1 (`stapp01`)** was successfully given executable permissions for all users.

Final permissions:

```text
-rwxr-xr-x
```

The script was successfully executed and returned:

```text
Welcome To KodeKloud
```

The challenge was completed successfully.
