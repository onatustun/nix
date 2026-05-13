{
  partitions.dev.module =
    { inputs, ... }:
    {
      imports = [ (inputs.make-shell + "/flake-module.nix") ];

      perSystem =
        { config, ... }:
        {
          devShells.nix-config = config.devShells.default;
        };
    };
}
