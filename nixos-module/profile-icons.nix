#https://github.com/uiriansan/SilentSDDM/blob/main/nix/module.nix
{
  config,
  lib,
  ...
}: let
  cfg = config.mtool.profile-icons;
  users = lib.attrsets.attrNames config.users.users;
in {
  options = {
    mtool.profile-icons = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "enable profile icons";
      };
      sources = lib.mkOption {
        type = lib.types.attrsWith {
          placeholder = "image";
          elemType = lib.types.path;
        };
        default = {};
        example = lib.literalExpression ''
          {
            # <username> = <path / drv>
            kokomi = "/images/kokomi/kokomi96024.png";
            rexies = fetchurl {
              url = "https://upload-os-bbs.hoyolab.com/upload/2021/09/22/84300862/129d3f6ded12d26d20ea4e4fa3e098d7_9177972037247649366.jpg";
              hash = ""
            };
          }
        '';
        description = "attrset containing <username>, <profile-img> map";
      };

      sources' = lib.mkOption {
        internal = true;
        readOnly = true;
        visible = false;
        default = cfg.sources;
        apply = lib.flip lib.pipe [
          (lib.attrsets.filterAttrs (user: _: lib.assertMsg (lib.elem user users) "programs.silentSDDM.profileIcons: '${user}' is not a valid user"))
          (lib.attrsets.mapAttrs (user: icon: [
            "f+ /var/lib/AccountsService/users/${user}  0600 root root -  [User]\\nIcon=/var/lib/AccountsService/icons/${user}\\n"
            "L+ /var/lib/AccountsService/icons/${user}  -    -    -    -  ${icon}"
          ]))
          lib.attrsets.attrValues
          lib.flatten
        ];
        description = "converts profileIcons attrset into systemd tmpfiles expressions";
      };
    };
  };
  config = lib.mkIf cfg.enable {
    systemd.tmpfiles.rules = lib.mkIf (cfg.sources != {}) cfg.sources';
  };
}
