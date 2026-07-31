# KodeBS APT repository

Debian packages published by KodeBS, served over GitHub Pages at
**https://kodebs.github.io/apt**.

Add it once and everything KodeBS ships — applications, scripts, tooling —
installs and updates through `apt`, like anything else on the machine.

## Set up

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

sudo apt update
```

Then install anything by name, and update it with everything else:

```bash
sudo apt install <package>
sudo apt upgrade
```

**https://kodebs.github.io/apt** lists what is currently available.

`amd64` only. The `.sources` format and `/etc/apt/keyrings` are what Ubuntu 24.04
and later expect; on 22.04 the same repository works written as a one-line
`.list` file with `signed-by=`.

## Removing it

```bash
sudo rm /etc/apt/sources.list.d/kodebs.sources /etc/apt/keyrings/kodebs.asc
sudo apt update
```

## How this repository is maintained

**Nothing here is edited by hand.** Every file is generated.

Each source project owns its own packaging and pushes here from its release
workflow: it builds the `.deb`, then runs `scripts/publish-apt.sh` to fold the
package into the pool, rebuild the indexes, sign them, and commit the result.
Adding a second or a tenth package needs no change to this repository.

```
kodebs.asc                     the public half of the signing key
index.html                     generated; lists every package currently held
pool/main/<initial>/<name>/    the .deb files themselves
dists/stable/                  Release, InRelease, Release.gpg
dists/stable/main/binary-amd64/  Packages, Packages.gz
```

The signing key's private half lives in the publishing project's Actions secrets
and nowhere else.

Currently published from:
[KodeBS/server-manager](https://github.com/KodeBS/server-manager).
