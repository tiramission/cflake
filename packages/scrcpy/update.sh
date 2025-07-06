#!usr/bin/env bash

version=$(curl -sSL https://api.github.com/repos/Genymobile/scrcpy/releases/latest | nix run nixpkgs#yq -- .tag_name -r)

function url_for() {
    echo "https://gh-proxy.com/github.com/Genymobile/scrcpy/releases/download/${version}/scrcpy-${1}-${version}.tar.gz"
}

function hash_for() {
    local url="https://gh-proxy.com/github.com/Genymobile/scrcpy/releases/download/${version}/SHA256SUMS.txt"
    local sha256=$(curl -sSL "${url}" | grep "${1}" | awk '{print $1}')
    nix hash convert --hash-algo sha256 --to sri ${sha256}
}

cat > $(dirname $(realpath "${BASH_SOURCE[0]}"))/version.json <<EOF
{
    "version": "${version}",
    "macos-aarch64": {
        "hash": "$(hash_for 'macos-aarch64')",
        "url": "$(url_for 'macos-aarch64')"
    },
    "linux-x86_64": {
        "hash": "$(hash_for 'linux-x86_64')",
        "url": "$(url_for 'linux-x86_64')"
    }
}
EOF
