{
  lib,
  stdenv,
  fetchzip,
}: let
  versionData = lib.importJSON ./version.json;
in
  stdenv.mkDerivation (finalAttrs: {
    pname = "zashboard";
    inherit (versionData) version;

    src = fetchzip {
      inherit (versionData) url hash;
    };

    dontConfigure = true;
    dontBuild = true;

    installPhase = ''
      mkdir -p $out
      mv * $out
    '';

    meta = {
      description = "Dashboard Using Clash API";
      homepage = "https://github.com/Zephyruso/zashboard";
      license = lib.licenses.mit;
      platforms = lib.platforms.all;
      maintainers = [];
    };
  })
