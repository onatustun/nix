{ inputs, ... }: {
  imports = [ (inputs.flake-root + "/flake-module.nix") ];

  perSystem = { config, ... }: with config.flake-root;
    {
      make-shells.default.inputsFrom = [ devShell ];
      treefmt = { inherit projectRootFile; };
    };
}
