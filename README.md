## Remote devbox
- Fastest isolated Linux-container approach for your machine.
- Already pre-installed base system and developer tools (check [Containerfile](./Containerfile))
- No Podman machine, no Docker Desktop: dynamic memory and disk, instant start.

### Install and use
#### Select your platform: [Windows](#windows) - [Mac](#mac) - [Linux](#linux)

#### Usage
```bash
# Work as with the remote ubuntu server: 
# Connect from Zed or VScode via "Open Remote".
ssh devbox
scp -r <any file on host> devbox:~/work

# Use shared dir between the host and the devbox:
# (command for host):
cp -r <some file or dir on host> ~/devbox/share
# or (inside the devbox):
cp -r <some file or dir on the devbox> /share
```

#### Common install steps
```bash
# Once: create shared dir with your ownership
mkdir -p ~/devbox-share

# Once: generate SSH key
ssh-keygen -t ed25519 -f ~/.ssh/devbox_ed25519 -C "devbox"
# add the config to your host: ~/.ssh/config
Host devbox
    HostName 127.0.0.1
    Port 2200
    User user
    IdentityFile ~/.ssh/devbox_ed25519
    IdentitiesOnly yes
# end
```

#### Windows
Isolated container for Unix development on Windows, powered by [WSL containers](https://learn.microsoft.com/en-us/windows/wsl/wsl-container) (`wslc`).

```powershell
# Install Deps:
wsl --update; wsl --version

# Install wslc-compose — runs compose.yaml on wslc
# (until Microsoft ships official compose: github.com/microsoft/WSL/issues/40948)
irm https://raw.githubusercontent.com/DawnMagnet/wslc-compose-go/main/scripts/install.ps1 | iex
wslc-compose up -d --build
wslc exec --user root -it devbox passwd user

# On fresh system start (no machine to boot; wslc has no restart policies):
wslc start devbox    # or: wslc-compose up -d

# Optional steps if needed

# Rebuild
wslc-compose up -d --build   # /home/user survives (named volume)

# Cleanup
wslc container prune -f   # stopped containers
wslc image prune -f       # dangling images (add -a for all unused)
wslc network prune -f     # unused networks
# Full reset
wslc volume prune -f    # ⚠ deletes the devbox home volume when the container is removed!
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
```bash
# Soon...
```

#### Support
You can always contact me and suggest a feature or send a bug report.\
It can also be done by creating an issue or pull request.\
Thank you!
