{
  pname,
  version,
  src,
  meta,
  appimageTools,
}:

let
  appimageContents = appimageTools.extract {
    inherit pname version src;
    postExtract = ''
      patchelf --replace-needed libtiff.so.5 libtiff.so $out/opt/wechat/wechat
    '';
  };
in
appimageTools.wrapAppImage {
  inherit pname version meta;

  src = appimageContents;
  # https://github.com/ryan4yin/nix-config/blob/main/hardening/bwraps/wechat.nix

  # Add these root paths to FHS sandbox to prevent WeChat from accessing them by default
  # Adapted from https://aur.archlinux.org/cgit/aur.git/tree/wechat-universal.sh?h=wechat-universal-bwrap
  extraPreBwrapCmds = ''
    XDG_DOCUMENTS_DIR="''${XDG_DOCUMENTS_DIR:-$(xdg-user-dir DOCUMENTS)}"
    if [[ -z "''${XDG_DOCUMENTS_DIR}" ]]; then
        echo 'Error: Failed to get XDG_DOCUMENTS_DIR, refuse to continue'
        exit 1
    fi

    WECHAT_DATA_DIR="''${XDG_DOCUMENTS_DIR}/WeChat_Data"

    # Using ''${WECHAT_DATA_DIR} as Wechat Data folder
    WECHAT_HOME_DIR="''${WECHAT_DATA_DIR}/home"
    WECHAT_FILES_DIR="''${WECHAT_DATA_DIR}/xwechat_files"

    mkdir -p "''${WECHAT_FILES_DIR}"
    mkdir -p "''${WECHAT_HOME_DIR}"
    ln -snf "''${WECHAT_FILES_DIR}" "''${WECHAT_HOME_DIR}/xwechat_files"
  '';

   extraBwrapArgs = [
    "--tmpfs /home"
    "--tmpfs /root"
    # format: --bind <host-path> <sandbox-path>
    "--bind \${WECHAT_HOME_DIR} \${HOME}"
    "--bind \${WECHAT_FILES_DIR} \${WECHAT_FILES_DIR}"
    "--chdir \${HOME}"
    # wechat-universal only supports xcb
    "--setenv QT_QPA_PLATFORM xcb"
    "--setenv QT_AUTO_SCREEN_SCALE_FACTOR 1"
    # use fcitx as IME
    "--setenv QT_IM_MODULE fcitx"
    "--setenv GTK_IM_MODULE fcitx"
  ];

  extraInstallCommands = ''
    mkdir -p $out/share/applications
    cp ${appimageContents}/wechat.desktop $out/share/applications/
    mkdir -p $out/share/icons/hicolor/256x256/apps
    cp ${appimageContents}/wechat.png $out/share/icons/hicolor/256x256/apps/

    substituteInPlace $out/share/applications/wechat.desktop --replace-fail AppRun wechat
  '';
}
