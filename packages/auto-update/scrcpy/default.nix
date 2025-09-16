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
  systemAttr = {
    "x86_64-linux" = "linux-x86_64";
    "aarch64-darwin" = "macos-aarch64";
  };
  versionSystem = systemAttr.${system};
in
  stdenv.mkDerivation rec {
    pname = "scrcpy";
    version = versionData.version;
    src = fetchurl {
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
      chmod +x $out/bin/adb $out/bin/scrcpy
    '';
    meta.platforms = [
      "x86_64-linux"
      "aarch64-darwin"
    ];
  }
