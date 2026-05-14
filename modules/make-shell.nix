{
  partitions.dev.module =
    { inputs, ... }:
    {
      imports = [ (inputs.make-shell + "/flake-module.nix") ];

      perSystem =
        { pkgs, config, ... }:
        {
          make-shells.default.stdenv = pkgs.stdenvNoCC;
          devShells.nix-config = config.devShells.default;
        };
    };
}
