{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.mtool.merge-json;
  scripts = import ./../libs/scripts/default.nix pkgs;
  toJsonFile = content: (pkgs.formats.json {}).generate "tojson" content;
in {
  options = {
    mtool.merge-json = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "merge json file into existing file";
      };
      contents = lib.mkOption {
        type = lib.types.attrsOf lib.types.attrs;
        default = {};
        description = "the contents to merge into the existing json file";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    home.activation.mergeJsonActivation = lib.hm.dag.entryAfter ["writeBoundary"] (
      let
        executeContentLists =
          lib.mapAttrsToList (name: value: let
            realPath = "${config.home.homeDirectory}/${name}";
            jsonFile = toJsonFile value;
          in ''
            ${scripts.mergeJsonPy} ${realPath} ${jsonFile} ${realPath}
          '')
          cfg.contents;
      in
        lib.concatLines executeContentLists
    );
  };
}
