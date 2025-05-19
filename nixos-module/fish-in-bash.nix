{
  config,
  lib,
  pkgs,
  ...
}: {
  options = {
    mtool.fish-in-bash.enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "enable fish when login to bash";
    };
  };
  config = lib.mkIf config.mtool.fish-in-bash.enable {
    programs.fish.enable = true;
    programs.bash = {
      interactiveShellInit = ''
        if [[ $(${pkgs.procps}/bin/ps --no-header --pid=$PPID --format=comm) != "fish" && -z ''${BASH_EXECUTION_STRING} ]]
        then
          shopt -q login_shell && LOGIN_OPTION='--login' || LOGIN_OPTION=""
          exec ${pkgs.fish}/bin/fish $LOGIN_OPTION
        fi
      '';
    };
  };
}
