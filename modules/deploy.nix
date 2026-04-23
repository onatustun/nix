{ lib, ... }:
let
  inherit (lib.options) mkOption;
  inherit (lib.types) submodule lazyAttrsOf anything;
in
{
  options.flake.deploy = mkOption {
    default = { };

    type = submodule {
      options.nodes = mkOption {
        default = { };
        type = lazyAttrsOf anything;
      };
    };
  };

  config.partitions.dev.module.perSystem =
    { inputs', pkgs, ... }:
    {
      make-shells.default.packages = [
        inputs'.deploy-rs.packages.default
        pkgs.nixos-anywhere
      ];
    };
}
