{
  inputs = {};
  outputs = {...} @ inputs: {
    nixosModules = import ./nixos-module/all.nix inputs;
    homeModules = import ./hm-module/all.nix inputs;
  };
}
