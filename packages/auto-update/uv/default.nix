{
  stdenv,
  fetchurl,
  gnutar,
  gzip,
  zlib,
  lib,
  system,
}: let
  versionData = lib.importJSON ./version.json;
in
  stdenv.mkDerivation rec {
    pname = "uv";
    version = versionData.version;

    src = let
      toMapSystem = {
        "x86_64-linux" = "x86_64-unknown-linux-musl";
        "aarch64-linux" = "aarch64-unknown-linux-musl";
        "aarch64-darwin" = "aarch64-apple-darwin";
      };
      versionSystem = toMapSystem.${system} or (throw "${system} is not supported");
    in
      fetchurl {
        # url = "https://github.com/astral-sh/uv/releases/download/${version}/uv-aarch64-apple-darwin.tar.gz";
        url = versionData."${versionSystem}".url;
        sha256 = versionData."${versionSystem}".hash;
      };

    nativeBuildInputs = [gnutar gzip];
    buildInputs = [zlib];
    dontConfigure = true;
    dontBuild = true;
    installPhase = ''
      mkdir -p $out/bin
      ${gnutar}/bin/tar -xzf $src --strip-components=1 -C $out/bin
      chmod +x $out/bin/uv $out/bin/uvx

      mkdir -p $out/share/bash-completion/completions
      mkdir -p $out/share/zsh/site-functions
      mkdir -p $out/share/fish/vendor_completions.d

      $out/bin/uv generate-shell-completion bash > $out/share/bash-completion/completions/uv.bash
      $out/bin/uv generate-shell-completion zsh > $out/share/zsh/site-functions/_uv
      $out/bin/uv generate-shell-completion fish > $out/share/fish/vendor_completions.d/uv.fish
    '';

    meta.platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "aarch64-darwin"
    ];
  }
