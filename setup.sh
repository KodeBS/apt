#!/bin/sh
#
# Add the KodeBS package repository, and install any packages named as arguments.
#
#   curl -fsSL https://kodebs.github.io/apt/setup.sh | sudo sh
#   curl -fsSL https://kodebs.github.io/apt/setup.sh | sudo sh -s package-one package-two
#
# Safe to run again: it rewrites its two files and changes nothing else.
set -eu

BASE="${KODEBS_APT_URL:-https://kodebs.github.io/apt}"
KEYRING=/etc/apt/keyrings/kodebs.asc
SOURCES=/etc/apt/sources.list.d/kodebs.sources

die() { printf '\nSetup failed: %s\n\n' "$1" >&2; exit 1; }
say() { printf '  %s\n' "$1"; }

[ "$(id -u)" = "0" ] || die "run this as root, for example:
  curl -fsSL $BASE/setup.sh | sudo sh"

if command -v curl >/dev/null 2>&1; then
  fetch() { curl -fsSL "$1"; }
elif command -v wget >/dev/null 2>&1; then
  fetch() { wget -qO- "$1"; }
else
  die "neither curl nor wget is installed:
  sudo apt install curl"
fi

printf '\nKodeBS package repository\n\n'

# ---- the signing key ----------------------------------------------------
# Fetched to a temporary file and checked before it is installed: a captive
# portal or a 404 page would otherwise be written out as a "key", and the only
# symptom would be a confusing apt error later on.
say "fetching the signing key"
TMPKEY="$(mktemp)"
trap 'rm -f "$TMPKEY"' EXIT INT TERM
fetch "$BASE/kodebs.asc" > "$TMPKEY" || die "could not download $BASE/kodebs.asc"
grep -q "BEGIN PGP PUBLIC KEY BLOCK" "$TMPKEY" ||
  die "what came back from $BASE/kodebs.asc is not a PGP key"

install -d -m 0755 /etc/apt/keyrings
install -m 0644 "$TMPKEY" "$KEYRING"
say "trusted as $KEYRING"

# ---- the repository -----------------------------------------------------
cat > "$SOURCES" <<SOURCESEOF
Types: deb
URIs: $BASE
Suites: stable
Components: main
Architectures: amd64
Signed-By: $KEYRING
SOURCESEOF
say "added as $SOURCES"

say "refreshing the package lists"
apt-get update -qq -o Dir::Etc::sourceparts=/etc/apt/sources.list.d ||
  die "apt could not read the repository — see the message above"

if [ "$#" -gt 0 ]; then
  printf '\n'
  say "installing: $*"
  DEBIAN_FRONTEND=noninteractive apt-get install -y "$@"
  printf '\nDone. Updates arrive with: sudo apt upgrade\n\n'
else
  printf '\nDone. Install anything from the repository with:\n\n  sudo apt install <package>\n\n'
  printf 'What is available: %s\n\n' "$BASE"
fi
