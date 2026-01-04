{
  lib,
  stdenv,
  fetchzip,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "zashboard";
  version = "2.5.0";

  src = fetchzip {
    url = "https://github.com/Zephyruso/zashboard/releases/download/v2.5.0/dist.zip";
    hash = "sha256-l5//MojNnmzNXne9j4pSJC9UC3nwB53NEqwGJWcaQQw=";
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
