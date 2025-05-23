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
    withSystems = supportedSystems: pkg:
      if builtins.elem system supportedSystems
      then pkg
      else null;
  in {
    sarasa-term-sc-nerd = pkgs.callPackage ./sarasa-term-sc-nerd.nix {};
    uv = pkgs.callPackage ./uv {};
    # 仅 x86_64-linux 支持
    microsoft-edge = withSystems ["x86_64-linux"] (pkgs.callPackage ./microsoft-edge {});
  })
