inputs: let
  systems = ["x86_64-linux" "aarch64-darwin" "aarch64-linux"];
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
    sarasa-term-sc-nerd = pkgs.callPackage ./manual/sarasa-term-sc-nerd.nix {};
    smctemp = pkgs.callPackage ./manual/smctemp.nix {};
    microsoft-edge = pkgs.callPackage ./manual/microsoft-edge.nix {};

    uv = pkgs.callPackage ./auto-update/uv {};
    scrcpy = pkgs.callPackage ./auto-update/scrcpy {};
    qq = pkgs.callPackage ./auto-update/qq {};
  })
