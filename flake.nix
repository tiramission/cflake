{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  };
  outputs = {...} @ inputs: {
    nixosModules = import ./nixos-module/all.nix inputs;
    homeModules = import ./hm-module/all.nix inputs;
    packages = import ./packages/all.nix inputs;
    overlays.default = final: prev: {cflake = inputs.self.packages.${prev.system};};
  };
}
