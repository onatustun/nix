{ lib, ... }:
let
  inherit (lib.options) mkOption;
  inherit (lib.types) lazyAttrsOf submodule deferredModule;
  inherit (lib.attrsets) mapAttrs;
  inherit (lib) nixosSystem;
in
{
  options.flake.configurations.nixos = mkOption {
    type = lazyAttrsOf (submodule {
      options.module = mkOption { type = deferredModule; };
    });

    default = { };
    apply = mapAttrs (_: host: nixosSystem { modules = [ host.module ]; });
  };

  config.flake =
    { config, ... }:
    {
      nixosConfigurations = config.configurations.nixos;
    };
}
