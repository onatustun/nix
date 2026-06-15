{ inputs, ... }: {
  imports = [ (inputs.flake-root + "/flake-module.nix") ];

  perSystem = { config, ... }: {
    make-shells.default.inputsFrom = [ config.flake-root.devShell ];
    treefmt = { inherit (config.flake-root) projectRootFile; };
  };
}
