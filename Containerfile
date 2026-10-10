FROM ubuntu:24.04

#  Avoid interactive prompts during installation
ENV DEBIAN_FRONTEND=noninteractive

# Install packages (grouped by purpose):
#   - Base, Editors File & search utils, System monitoring
#   - Network, Build toolchain, Python, SSH server, File sync
RUN apt-get update -y && apt-get install -y --no-install-recommends \
        bash sudo curl ca-certificates unzip git \
        nano less tmux \
        jq ripgrep fd-find fzf tree file \
        procps htop lsof iputils-ping \
        net-tools iproute2 dnsutils socat netcat-openbsd openssh-client \
        cmake ccache ninja-build clang lldb clangd libclang-rt-dev libc6-dev \
        python3 python3-venv python3-pip python3-dev \
        openssh-server \
        rsync && \
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

RUN mkdir -p /share && chown user:user /share
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
