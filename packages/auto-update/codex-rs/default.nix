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
  toMapSystem = {
    "x86_64-linux" = "x86_64-unknown-linux-musl";
    "aarch64-linux" = "aarch64-unknown-linux-musl";
    "aarch64-darwin" = "aarch64-apple-darwin";
  };
  versionSystem = toMapSystem.${system} or (throw "${system} is not supported");
in
  stdenv.mkDerivation rec {
    pname = "codex-rs";
    version = versionData.version;

    src = fetchurl {
      url = versionData."${versionSystem}".url;
      sha256 = versionData."${versionSystem}".hash;
    };

    nativeBuildInputs = [gnutar gzip];
    buildInputs = [zlib];
    dontConfigure = true;
    dontBuild = true;
    dontUnpack = true;

    installPhase = ''
      runHook preInstall

      mkdir -p $out/bin
      tmpdir=$(mktemp -d)
      ${gnutar}/bin/tar -xzf $src -C "$tmpdir"
      install -m755 "$tmpdir/codex-${versionSystem}" $out/bin/codex

      runHook postInstall
    '';

    meta.platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "aarch64-darwin"
    ];
  }
