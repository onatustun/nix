{
  flake =
    { lib, ... }:
    let
      inherit (lib.options) mkOption;
      inherit (lib.types) submodule lazyAttrsOf anything;
    in
    {
      options.deploy = mkOption {
        default = { };

        type = submodule {
          options.nodes = mkOption {
            default = { };
            type = lazyAttrsOf anything;
          };
        };
      };
    };

  partitions.dev.module =
    { inputs, config, ... }:
    {
      perSystem =
        { system, inputs', ... }:
        {
          checks = inputs.deploy-rs.lib.${system}.deployChecks config.flake.deploy;
          make-shells.default.packages = [ inputs'.deploy-rs.packages.default ];
        };
    };
}
