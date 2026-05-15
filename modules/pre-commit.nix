{
  partitions.dev.module =
    { inputs, ... }:
    {
      imports = [ (inputs.git-hooks + "/flake-module.nix") ];

      perSystem =
        { config, ... }:
        {
          make-shells.default.inputsFrom = [ config.pre-commit.devShell ];
          pre-commit.settings.hooks.flake-checker.enable = true;
        };
    };
}
