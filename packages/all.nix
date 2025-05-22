inputs: let
  systems = ["x86_64-linux" "aarch64-linux"];
  forAllSystems = inputs.nixpkgs.lib.genAttrs systems;
  nixpkgsFor = forAllSystems (system:
    import inputs.nixpkgs {
      inherit system;
      config = {
        allowUnfree = true;
      };
    });
in
  forAllSystems (system: let
    pkgs = nixpkgsFor.${system};
  in {
    sarasa-term-sc-nerd = pkgs.callPackage ./sarasa-term-sc-nerd.nix {};
    uv = pkgs.callPackage ./uv {};
    microsoft-edge = pkgs.callPackage ./microsoft-edge {};
  })
