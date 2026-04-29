{ lib, inputs, ... }:
let
  inherit (lib.options) mkOption;
  inherit (lib.types) lazyAttrsOf raw;
in
{
  imports = [ inputs.disko.flakeModules.default ];

  options.flake.configurations.disko = mkOption {
    default = { };
    type = lazyAttrsOf raw;
  };

  config = {
    partitions.dev.module.perSystem =
      { inputs', ... }:
      {
        make-shells.default.packages = [ inputs'.disko.packages.default ];
      };

    flake =
      { config, ... }:
      {
        diskoConfigurations = config.configurations.disko;
      };
  };
}
