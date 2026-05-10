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

  config.partitions.dev.module =
    { inputs, config, ... }:
    {
      perSystem =
        {
          lib,
          system,
          inputs',
          ...
        }:
        let
          inherit (lib.modules) mkIf;
        in
        {
          checks = mkIf (inputs.deploy-rs.lib ? ${system}) (
            inputs.deploy-rs.lib.${system}.deployChecks config.flake.deploy
          );

          make-shells.default.packages = [ inputs'.deploy-rs.packages.default ];
        };
    };
}
