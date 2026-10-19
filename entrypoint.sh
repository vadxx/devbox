#!/bin/sh
set -eu

install -d -m 700 -o user -g user /home/user/.ssh
install -m 600 -o user -g user \
  /run/devbox_authorized_key \
  /home/user/.ssh/authorized_keys

# self-heal ownership of ~/work on volumes created before the fix
install -d -o user -g user /home/user/work

exec /usr/sbin/sshd -D -e
