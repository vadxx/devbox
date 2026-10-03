## Remote devbox
Isolated container for Unix development.
Already pre-installed developer tools: git, python, cmake, ninja clang, lldb...

#### Install and use
```bash
# First: install Podman and Docker compose
# Windows:
# winget install --id RedHat.Podman -e --accept-source-agreements --accept-package-agreements
# winget install --id Docker.DockerCompose -e --accept-source-agreements --accept-package-agreements

# Second: once generate SSH key
ssh-keygen -t ed25519 -f ~/.ssh/devbox_ed25519 -C "devbox"
# add the config to your host: ~/.ssh/config
Host devbox
    HostName 127.0.0.1
    Port 2200
    User user
    IdentityFile ~/.ssh/devbox_ed25519
    IdentitiesOnly yes
# end

podman machine init --cpus 4 --disk-size 25 -m 2048
# Note: disk size in GB

podman machine start
podman compose up -d --build
podman exec --user root -it devbox passwd user

# usage:
# Work as on the remote ubuntu host: 
# Connect from Zed or VScode via "Open Remote".
ssh devbox
scp -r <any file on host> devbox:~/work
```

#### Support
You can always contact me and suggest a feature or send a bug report.
It can also be done by creating an issue or pull request.
Thank you!
