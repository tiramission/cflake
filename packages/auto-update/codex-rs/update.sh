#!usr/bin/env bash

set -euo pipefail

release=$(curl -fsSL https://api.github.com/repos/openai/codex/releases/latest)
tag=$(printf '%s' "$release" | nix run nixpkgs#yq -- .tag_name -r)
version=$(printf '%s' "$release" | nix run nixpkgs#yq -- .name -r)

function url_for() {
    echo "https://github.com/openai/codex/releases/download/${tag}/codex-${1}.tar.gz"
}

function hash_for() {
    nix-prefetch-url --type sha256 "$(url_for "$1")" | xargs nix hash convert --hash-algo sha256 --to sri
}

cat > $(dirname $(realpath "${BASH_SOURCE[0]}"))/version.json <<EOF
{
    "version": "${version}",
    "aarch64-apple-darwin": {
        "hash": "$(hash_for 'aarch64-apple-darwin')",
        "url": "$(url_for 'aarch64-apple-darwin')"
    },
    "aarch64-unknown-linux-musl": {
        "hash": "$(hash_for 'aarch64-unknown-linux-musl')",
        "url": "$(url_for 'aarch64-unknown-linux-musl')"
    },
    "x86_64-unknown-linux-musl": {
        "hash": "$(hash_for 'x86_64-unknown-linux-musl')",
        "url": "$(url_for 'x86_64-unknown-linux-musl')"
    }
}
EOF
