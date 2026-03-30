#!usr/bin/env bash

set -euo pipefail

version=$(curl -fsSL https://api.github.com/repos/Zephyruso/zashboard/releases/latest | nix run nixpkgs#yq -- .name -r)
version=${version#v}
url="https://github.com/Zephyruso/zashboard/releases/download/v${version}/dist.zip"
hash=$(nix-prefetch-url --type sha256 ${url} | xargs nix hash convert --hash-algo sha256 --to sri)

cat > $(dirname $(realpath "${BASH_SOURCE[0]}"))/version.json <<EOF
{
    "version": "${version}",
    "url": "${url}",
    "hash": "${hash}"
}
EOF
