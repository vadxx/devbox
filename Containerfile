FROM ubuntu:24.04

#  Avoid interactive prompts during installation
ENV DEBIAN_FRONTEND=noninteractive

# Install packages then do cleanup
RUN apt-get update -y && apt-get install -y --no-install-recommends \
        cmake ccache git tmux \
        ninja-build clang lldb clangd libclang-rt-dev \
        python3 python3-venv python3-pip python3-dev \
        bash sudo curl \
        openssh-server ca-certificates && \
    rm -rf /var/lib/apt/lists/*

# user, ssh setup and disable user login message
RUN mkdir -p /run/sshd && \
    printf '%s\n' \
      'PermitRootLogin no' \
      'PasswordAuthentication no' \
      'KbdInteractiveAuthentication no' \
      'PubkeyAuthentication yes' \
      'AuthorizedKeysFile .ssh/authorized_keys' \
      'Subsystem sftp internal-sftp' \
      >> /etc/ssh/sshd_config

RUN useradd --create-home --shell /bin/bash user && \
    usermod -aG sudo user && \
    mkdir -p /home/user/.ssh /home/user/work && \
    touch /home/user/.hushlogin && \
    chown -R user:user /home/user && \
    chmod 700 /home/user/.ssh

WORKDIR /home/user/work
EXPOSE 22

# fix colors
ENV TERM=xterm-256color
ENV COLORTERM=truecolor
RUN sed -i 's/#force_color_prompt=yes/force_color_prompt=yes/' /etc/skel/.bashrc \
    && sed -i 's/#force_color_prompt=yes/force_color_prompt=yes/' /root/.bashrc 2>/dev/null || true

# Start
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
