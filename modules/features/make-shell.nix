{ inputs, ... }: {
  imports = [ (inputs.make-shell.sourceInfo.outPath + "/flake-module.nix") ];

  perSystem = { pkgs, config, ... }: {
    make-shells.default.stdenv = pkgs.stdenvNoCC;
    devShells.nix-config = config.devShells.default;
  };
}
