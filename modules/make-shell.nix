{
  partitions.dev.module =
    { inputs, ... }:
    {
      imports = [ inputs.make-shell.flakeModules.default ];

      perSystem =
        { config, ... }:
        {
          devShells.nix-config = config.devShells.default;
        };
    };
}
