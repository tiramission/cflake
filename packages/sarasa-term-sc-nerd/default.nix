{
  lib,
  stdenv,
  fetchurl,
  p7zip,
}:
stdenv.mkDerivation rec {
  pname = "sarasa-term-sc-nerd";
  version = "2.3.1";

  src = fetchurl {
    url = "https://ghproxy.net/https://github.com/laishulu/Sarasa-Term-SC-Nerd/releases/download/v${version}/SarasaTermSCNerd.ttf.7z";
    sha256 = "sha256-REg7dJ7YJhEcFQ43+SIJkncJu1PsUCESlwHMfZftoKk=";
  };

  nativeBuildInputs = [p7zip];

  sourceRoot = ".";

  unpackPhase = ''
    7z x $src
  '';

  installPhase = ''
    mkdir -p $out/share/fonts/truetype
    cp *.ttf $out/share/fonts/truetype/
  '';

  meta = with lib; {
    description = "简体中文终端更纱黑体+Nerd图标字体库";
    homepage = "https://github.com/laishulu/Sarasa-Term-SC-Nerd";
    license = licenses.ofl;
    platforms = platforms.all;
    maintainers = with maintainers; [];
  };
}
