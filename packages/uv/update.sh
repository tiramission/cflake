#!usr/bin/env bash

set -e

version=$(curl -fsSL https://api.github.com/repos/astral-sh/uv/releases/latest | nix run nixpkgs#yq -- .name -r)

function url_for() {
    echo "https://gh-proxy.com/github.com/astral-sh/uv/releases/download/${version}/uv-${1}.tar.gz"
}

function hash_for() {
    local url="https://gh-proxy.com/github.com/astral-sh/uv/releases/download/${version}/uv-${1}.tar.gz.sha256"
    local sha256=$(curl -sSL "${url}" | awk '{print $1}')
    nix hash convert --hash-algo sha256 --to sri ${sha256}
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
