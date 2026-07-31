# KodeBS APT repository

Debian packages published by KodeBS, served over GitHub Pages at
**https://kodebs.github.io/apt**.

Add it once and everything KodeBS ships — applications, scripts, tooling —
installs and updates through `apt`, like anything else on the machine.

## Set up

One command:

```bash
curl -fsSL https://kodebs.github.io/apt/setup.sh | sudo sh
```

That trusts the signing key and adds the repository. Name packages after it to
install them at the same time:

```bash
curl -fsSL https://kodebs.github.io/apt/setup.sh | sudo sh -s kodebs-server-manager
```

<details>
<summary>Rather not pipe a script into a root shell? Do the same by hand.</summary>

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

</details>

## Using it

Install anything by name, and update it with everything else:

```bash
sudo apt install <package>
sudo apt upgrade
```

**https://kodebs.github.io/apt** lists what is currently available.

`amd64` only. The `.sources` (deb822) format works on Ubuntu 22.04 through 26.04
alike — verified by installing from this repository inside both a 22.04 and a
24.04 container.

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
setup.sh                       generated; the one-command installer above
index.html                     generated; lists every package currently held
pool/main/<initial>/<name>/    the .deb files themselves
dists/stable/                  Release, InRelease, Release.gpg
dists/stable/main/binary-amd64/  Packages, Packages.gz
```

The signing key's private half lives in the publishing project's Actions secrets
and nowhere else.

Currently published from:
[KodeBS/server-manager](https://github.com/KodeBS/server-manager).
