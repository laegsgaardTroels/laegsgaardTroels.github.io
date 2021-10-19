---
image: "/assets/images/base/linux.svg"
category: Bash
---

Useful commands and operators. <!--more-->

#### `||` and `&&`

See [3]. 

AND and OR lists are sequences of one or more pipelines separated by the control operators `&&` and `||`, respectively. AND and OR lists are executed with left associativity.

An AND list has the form

```bash
command1 && command2
command2 is executed if, and only if, command1 returns an exit status of zero (success).
```

An OR list has the form

```bash
command1 || command2
command2 is executed if, and only if, command1 returns a non-zero exit status.
```

The return status of AND and OR lists is the exit status of the last command executed in the list.

The `&&` and `||` also works as logical AND and OR operators:

```bash
true || echo foo                   # Doesn't echo anything.
false || echo foo                  # Echos foo.
true && echo foo                   # Echos foo.
false && echo foo                  # Doesn't echo anything.
```

Below can be useful in a Makefile if you don't care if the command was succesful. E.g. if you want to make sure something has been removed. 

```bash
some_command || true
```

#### Change directory with `cd`

```bash
cd to/new/directory/
cd -                               # Go back to previous directory.
```

#### Clear the shell with `clear`

Enough said.

```bash
clear
```

#### Remove file with `rm`

```bash
rm file.txt                        # Remove file.
rm -rf folder                      # Remove folder.
```

#### Create a directory with `mkdir`

```bash
mkdir new_dir
mkdir -p new_dir                   # New error if existing and create parent folders.
```

#### Move and renmae file with `mv`

```bash
mv file.txt other.txt              # Rename.
mv file.txt folder/file.txt        # Move to folder.
```

#### List files with `ls`

```bash
ls
ls -l                              # To view permissions.
```

#### Kill a process with `kill`

You get the process id (`<PID>`) from `top` or `ps`.

```bash
kill <PID>
```

#### View running processes with `top` and `htop`

```bash
top
top -u trol                        # Filter on a single user.
htop                               # Nicer UI and some extra stuff.
```

#### View running processes with `ps`

```bash
ps
ps -u trol                        # Filter on a single user.
```

#### File System Disk Space with `df`

```bash
df
```

#### Pathname of the current working directory with `pwd`

```bash
pwd
```

#### No Hang Up with `nohup`

Start a command in the background and exit the subshell.

```bash
nohup <COMMAND> &
exit
```

You can now view the job running here:

```bash
jobs
```

#### Disk Usage with `du`

View the disk usage in the current directory.

```bash
du -h -s
```

To go a bit deeper use.

```bash
du -h -d 2
```

etc.

#### File Tree with `tree`

View the file tree in the terminal up to a certain level.

```bash
tree -L 2
```

#### Run scheduled jobs with `cron`

A time based scheduler in unix. An hourly **cronjob** can look like this:

```bash
crontab -l
0 * * * * /bin/python /path/to/this/file.py
```

#### Create a tarball with `tar`

```bash
tar -cvf foo.tar file1 file2  # Compress, verbose, file
tar -xvf foo.tar              # Extract, verbose, file
```

#### Transfer data from a URL with `curl`

Below will get you the HTML for Google:

```bash
curl www.google.com
```

#### Transfer data with `wget`

Below will get you the index file for Google:

```bash
wget www.google.com
```
It has a useful option to mirror an external source, could be an FTP server or similar.

```bash
wget -m url
```

#### Split and combine files with `split` and `cat`

`split` and `cat` can be used to split a file and concatentate it again.

```bash
# file.txt
a
b
c
d
e
f
g
```

Then use:

```bash
split -l 1 combined.txt splitted
cat splitted* > combined.txt
```

You can actually split a tarball and combine it again afterwards:

```bash
split combined.tar.gz splitted
cat splitted* > combined.tar.gz
```

Can be useful for file transfer if you have a very big tarball.

#### Global regular expression print with `grep`

Awesome tool for searching for text in files.

Search for a pattern in the current folder and optionally sub-directories.

```bash
grep <PATTERN> *
grep -r <PATTERN> *
```
It can often be useful to grep from your bash history.

```bash
history | grep foo
```

#### Find and replace with `sed`

Replace all occurences of bash with linux in file.txt and redirect the output to `new_file.txt`

```bash
sed 's/bash/linux/g' file.txt > new_file.txt
```

You can use another seperator, in below I use `:` instead of `/`:

```bash
sed -i 's:<title>slides slides</title>:<title>Slides</title>:g'
```

#### Find files with `find`

Below will find all shell scripts.

```bash
find . -type f -name *.sh
```
Below will find and delete files created by R and Python.

```bash
find . -type f -name "*.py[co]" -delete
find . -type d -name "__pycache__" -delete
find . -type f -name ".Rhistory" -delete
find . -type f -name ".RData" -delete
```
Find and execute a command. Below will extract all tarballs in `./folder/with/tarballs`.

```bash
find ./folder/with/tarballs \
  -name '*.tgz' \
  -type f \
  -exec \
  tar --one-top-level -C ./folder/with/tarballs -zxvf {}  \;
```

Using -exec with a semicolon (`find . -exec ls '{}' \;`), will execute

```bash
ls file1
ls file2
ls file3
```

But if you use a plus sign instead (`find . -exec ls '{}' \+`), as many filenames as possible are passed as arguments to a single command:

```bash
ls file1 file2 file3
```

The number of filenames is only limited by the system's maximum command line length. If the command exceeds this length, the command will be called multiple times.

#### Secure shell to a remote machine with `ssh`

`ssh` is useful for logging into a remote machine and execute commands on it.

I've found it useful to create a SSH tunnel when developing a `bokeh` server on a remote host.

```bash
ssh -NfL localhost:5006:localhost:5006 user@remote.host
```

#### Create a checksum with `sha256sum` and `md5sum`

```bash
sha256sum /path/to/file
sha256sum /path/to/files/*
md5sum /path/to/file
md5sum /path/to/files/*
```

And check the checksums with.

```bash
sha256sum /path/to/files/* > checksums.sha256
sha256sum --check checksums.sha256
```
and 

```bash
md5sum /path/to/files/* > checksums.md5
md5sum --check checksums.md5
```
#### `scp` for secure transfer of files via `ssh`.

Enough said.

#### Change user/group with `chown` and permissions with `chmod`

The `chmod` (short for change mode) command is used to manage file system access permissions on Unix and Unix-like systems. There are three basic file system permissions, or modes, to files and directories, see [2]:

- `read (r)`
- `write (w)`
- `execute (x)` Can i do a `ls` in a directory as an example.
- 
Each mode can be applied to these classes:

- `user (u)` The user is the account that owns the file.
- `group (g)` The group that owns the file may have other accounts on the system as members.
- `other (o)` The remaining class, other (sometimes referred to as world), means all other accounts on the system.

From `man chmod`: `Each MODE is of the form '[ugoa]*([-+=]([rwxXst]*|[ugo]))+|[-+=][0-7]+'.`

The references are shorthand (u, g, or o) for each class. The operator determines whether to add (+), remove (-) or explicitly set (=) the particular permissions. The modes are read (r), write (w), or execute (x).

You can combine multiple references and modes to set the desired access all at once. For example, to explicitly make file3 readable and executable to everyone:

```bash
chmod ugo=rx file3   # user(u),group(g),other(o)=read(r),execute(x)
```

**Example:** The `chown` changes the ownership of all files and folders to user: tlg and group: users. The `chmod` changes changes the permissions to to read, write for user and groups.

```bash
sudo chown tlg:users -R .
sudo chmod ug=rwx -R .
ll
```

#### Sync data with `rsync`

#### Mount a folder with `nfs`

#### JSON processing with `jq`

#### Download data from FTP server with `lftp`

#### Get the current user with `whoami`

```
whoami                                      # Outputs: troels (or whatever username you have).
```

# References

[1] https://stedolan.github.io/jq/

[2] https://cets.seas.upenn.edu/answers/chmod.html

[3] https://www.gnu.org/savannah-checkouts/gnu/bash/manual/bash.html#Lists
