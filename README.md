# KodeBS APT repository

The package repository for
[KodeBS Server Manager](https://github.com/KodeBS/server-manager), served over
GitHub Pages at **https://kodebs.github.io/apt**.

## Installing the app

```bash
sudo install -d -m 0755 /etc/apt/keyrings
curl -fsSL https://kodebs.github.io/apt/kodebs.asc | \
  sudo tee /etc/apt/keyrings/kodebs.asc > /dev/null

sudo tee /etc/apt/sources.list.d/kodebs.sources > /dev/null <<'EOF'
Types: deb
URIs: https://kodebs.github.io/apt
Suites: stable
Components: main
Architectures: amd64
Signed-By: /etc/apt/keyrings/kodebs.asc
EOF

sudo apt update && sudo apt install kodebs-server-manager
```

New versions arrive with `sudo apt upgrade`.

## About this repository

Everything here is generated. Nothing is edited by hand.

Tagging a version in `KodeBS/server-manager` builds the `.deb`, and its workflow
then runs `scripts/publish-apt.sh` from that repo to fold the package in, rebuild
the indexes, sign them and push the result here.

```
kodebs.asc                              the public half of the signing key
pool/main/k/kodebs-server-manager/      the .deb files themselves
dists/stable/                           Release, InRelease, Release.gpg
dists/stable/main/binary-amd64/         Packages, Packages.gz
```

`amd64` only. The signing key's private half lives in that repository's Actions
secrets and nowhere else.
