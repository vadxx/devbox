#!/bin/sh
set -eu

install -d -m 700 -o user -g user /home/user/.ssh
install -m 600 -o user -g user \
  /run/devbox_authorized_key \
  /home/user/.ssh/authorized_keys

exec /usr/sbin/sshd -D -e
