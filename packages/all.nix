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
      else throw ("Current system " + system + " is not supported for this package. Supported: " + builtins.toString supportedSystems);
    withLinuxs = withSystems ["x86_64-linux" "aarch64-linux"];
  in {
    sarasa-term-sc-nerd = withLinuxs (pkgs.callPackage ./sarasa-term-sc-nerd {});
    uv = pkgs.callPackage ./uv {};
    scrcpy = withSystems ["x86_64-linux" "aarch64-darwin"] (pkgs.callPackage ./scrcpy {});
    microsoft-edge = withSystems ["x86_64-linux"] (pkgs.callPackage ./microsoft-edge {});
  })
