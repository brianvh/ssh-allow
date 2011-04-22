# ssh-allow

A mini-DSL for specifying which remote SSH commands are allowed (or denied) during a remote shell session, authenticated via an SSH key. Also comes with a command-line binary for comparing the current remote command against the list.

## Purpose

Guarding against the SSH_REMOTE_COMMAND environment is fairly command and allowing/denying simple commands is easy to do with a simple bash shell. Unfortunately, if what you need to do is allow a very narrow set of non-trivial commands, where the various command-line options and arguments need to be specified, trying to accomplish this with a bash script quickly becomes arduous.

To try and solve this problem, I developed an extremely simple _DSL_, which is really just some stripped down ruby code, that would make specifying almost any range of commands, with almost any range of options and/or arguments, a straightforward problem. Those **rules** needed a specialized command-line binary to both process them and compare the allowed (or denied) commands against ENV['SSH_REMOTE_COMMAND'].

That's ssh-allow.

---

## Installation

    $ sudo gem install ssh-allow

---

## Usage

### guard (default command)

    $ ssh-allow guard [-r | --rules=<file>] [-e | --echo]

The --rules `<file>` path defaults to `~/.ssh-rules`. If the intent is to deploy ssh-allow across multiple accounts on a single Unix/Linux server, then it's recommended that you create `/etc/ssh-allow/` to hold the various rules files.

The --echo switch echos the command to std_in, prior to executing it.

The guard command is intended to be specified in the ~/.ssh/authorized_keys file, as the front-part of the line containing the SSH key that needs command guarding. The configuration usually looks like this:

    command="/usr/local/bin/ssh-allow guard -r=/etc/ssh-allow/rule_file" ssh-rsa AAAAB3Nza

---

## Rules Specification DSL

Allowing an `ls` command, with no options and no arguments.

```ruby
allow!('ls')
```

Allowing an `ls` command, with any options and any arguments.

```ruby
allow!('ls') do
  opts :any
  args :any
end
```

Allowing an `ls` command, with a specific option and a file-path argument regex.

```ruby
allow!('ls') do
  opts '-ld'
  args '^/foo/bar/.*'
end
```

Allowing a `cp` command, with no options and two file-path argument regexes.

```ruby
allow!('cp') do
  args '^/foo/bar/.*'
  args '^/foo/baz/.*'
end
```
