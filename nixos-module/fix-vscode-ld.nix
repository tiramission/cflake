{
  config,
  lib,
  pkgs,
  ...
}: {
  options = {
    mtool.fix-vscode-ld.enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "use nix-ld-rs to fix vscode remote";
    };
  };
  config = lib.mkIf config.mtool.fix-vscode-ld.enable {
    programs.nix-ld = {
      enable = true;
      package = pkgs.nix-ld-rs;
    };
  };
}
