{ lib, ... }:
let
  inherit (lib.options) mkOption;

  inherit (lib.types)
    lazyAttrsOf
    submodule
    deferredModule
    raw
    ;

  inherit (lib) nixosSystem;
in
{
  options.flake.configurations.nixos = mkOption {
    default = { };

    type = lazyAttrsOf (
      submodule (
        { config, ... }:
        {
          options = {
            module = mkOption { type = deferredModule; };

            result = mkOption {
              type = raw;
              readOnly = true;
              default = nixosSystem { modules = [ config.module ]; };
            };
          };
        }
      )
    );
  };

  config.flake =
    { lib, config, ... }:
    let
      inherit (lib.attrsets) mapAttrs;
    in
    {
      nixosConfigurations = mapAttrs (_: value: value.result) config.configurations.nixos;
    };
}
