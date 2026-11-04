## Remote devbox
- Fastest isolated Linux-container approach for your machine.
- Already pre-installed base system and developer tools (check [Containerfile](./Containerfile))

#### Common usage example
```shell
# Work as on the remote ubuntu host: 
# Connect from Zed or VScode via "Open Remote".
ssh devbox
scp -r <any file on host> devbox:~/work
# Use shared dir between the host and the devbox:
# (command for host):
cp -r <some file or dir on host> ~/devbox/share
# or (inside the devbox):
cp -r <some file or dir on the devbox> /share
```

### Install and use
#### Select your platform: [Windows](#windows) - [Mac](#mac) - [Linux](#linux)

#### Common step - do first once
```shell
# generate SSH key
ssh-keygen -t ed25519 -f ~/.ssh/devbox_ed25519 -C "devbox"
# add the config to your host: ~/.ssh/config
Host devbox
    HostName 127.0.0.1
    Port 2200
    User user
    IdentityFile ~/.ssh/devbox_ed25519
    IdentitiesOnly yes
# end

mkdir -p ~/devbox-share  # Create shared dir with your ownership
```

#### Windows
Isolated container for Unix development on Windows, powered by [WSL containers](https://learn.microsoft.com/en-us/windows/wsl/wsl-container) (`wslc`).

```powershell
# Install Deps:
wsl --update; wsl --version

# Install wslc-compose — runs compose.yaml on wslc
# (until Microsoft ships official compose: github.com/microsoft/WSL/issues/40948)
irm https://raw.githubusercontent.com/DawnMagnet/wslc-compose-go/main/scripts/install.ps1 | iex


# Generate the ssh key and add ~/.ssh/config as in the Common section
wslc-compose pull          # prebuilt image from ghcr
wslc-compose up -d         # no local build; --build overrides it
wslc exec --user root -it devbox passwd user

# Usage:
# On fresh system start (no machine to boot; wslc has no restart policies):
wslc start devbox    # or: wslc-compose up -d

# Update to the newest image
# (wslc-compose won't recreate the container when only the image behind the
#  same tag changed — hence --force-recreate)
wslc-compose pull
wslc-compose up -d --force-recreate

# Rebuild locally if needed
wslc-compose up -d --build   # /home/user survives (named volume)

# Cleanup
wslc container prune -f   # stopped containers
wslc image prune -f       # dangling images (add -a for all unused)
wslc network prune -f     # unused networks
# Full reset
wslc volume prune -f    # deletes the devbox home volume when the container is removed!
wslc system session list
wslc system session terminate <id>
# then delete %LOCALAPPDATA%\wslc\sessions

# Uninstall wslc-compose (Community tool)
& ([scriptblock]::Create((irm https://raw.githubusercontent.com/DawnMagnet/wslc-compose-go/main/scripts/install.ps1))) -Uninstall
```

#### Mac
```bash
# Soon...
```

#### Linux
Native Docker — no VM layer, already the fastest option (same role as wslc on Windows).

```bash
# Install Docker Engine + compose plugin: https://docs.docker.com/engine/install/
# Generate the ssh key and add ~/.ssh/config as in the Common section
docker compose pull && docker compose up -d   # prebuilt image, no local build
docker exec --user root -it devbox passwd user

# Usage:
# Auto-starts on boot (restart: unless-stopped), or manually:
docker start devbox    # or: docker compose up -d

# Update to the newest image
# (docker compose recreates the container itself when the image changed —
#  no --force-recreate needed, unlike wslc)
docker compose pull && docker compose up -d

# Rebuild locally if needed
docker compose up -d --build   # /home/user survives (named volume)

# Cleanup
docker compose down       # stop & remove the container
docker compose down -v    # also deletes the devbox home volume!
```

#### Support
You can always contact me and suggest a feature or send a bug report.\
It can also be done by creating an issue or pull request.\
Thank you!
