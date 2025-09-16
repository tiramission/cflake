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
    uv = pkgs.callPackage ./auto-update/uv {};
    smctemp = pkgs.callPackage ./manual/smctemp.nix {};
    scrcpy = pkgs.callPackage ./auto-update/scrcpy {};
    microsoft-edge = pkgs.callPackage ./manual/microsoft-edge.nix {};
    qq = pkgs.callPackage ./auto-update/qq {};
  })
