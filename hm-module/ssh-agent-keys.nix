{
  config,
  lib,
  pkgs,
  ...
}: {
  options = {
    mtools.ssh-agent-keys = {
      enable = lib.mkEnableOption "automatically add SSH keys to ssh-agent";
      keys = lib.mkOption {
        type = lib.types.listOf lib.types.path;
        default = [];
        description = "SSH keys to add to ssh-agent";
      };
    };
  };

  config = lib.mkIf config.mtools.ssh-agent-keys.enable (
    let
      cfg = config.services.ssh-agent;
      socketPath =
        if pkgs.stdenv.isDarwin
        then "$(${lib.getExe pkgs.getconf} DARWIN_USER_TEMP_DIR)/${cfg.socket}"
        else "$XDG_RUNTIME_DIR/${cfg.socket}";
      ssh-add = "${lib.getExe' config.services.ssh-agent.package "ssh-add"}";
      addGitKeys = pkgs.writeShellScriptBin "ssh-add-git-keys" ''
        SSH_AUTH_SOCK="${socketPath}"
        until [ -S "$SSH_AUTH_SOCK" ]; do
          sleep 0.2
        done
        ${lib.concatMapStrings (f: ''
            ${ssh-add} - < ${f}
          '')
          config.mtools.ssh-agent-keys.keys}
      '';
    in {
      assertions = [
        {
          assertion = config.mtools.ssh-agent-keys.enable -> config.services.ssh-agent.enable;
          message = "mtools.ssh-agent-keys.enable requires services.ssh-agent.enable";
        }
      ];
      systemd.user.services.ssh-agent = lib.mkIf (!pkgs.stdenv.isDarwin) {
        Service.ExecStartPost = "${addGitKeys}/bin/ssh-add-git-keys";
      };

      launchd.agents.ssh-agent-post = lib.mkIf pkgs.stdenv.isDarwin {
        enable = true;
        config = {
          ProgramArguments = ["${addGitKeys}/bin/ssh-add-git-keys"];
          RunAtLoad = true;
          KeepAlive = true;
        };
      };
    }
  );
}
