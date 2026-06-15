{ inputs, ... }: {
  disabledModules = [ inputs.flake-parts.flakeModules.nixosConfigurations ];

  flake =
    { lib, ... }:
    let
      inherit (lib.options) mkOption;
      inherit (lib.types) lazyAttrsOf submodule deferredModule;
      inherit (lib.attrsets) mapAttrs;
      inherit (lib) nixosSystem;
    in
    {
      options.nixosConfigurations = mkOption {
        type = lazyAttrsOf (submodule {
          options.module = mkOption { type = deferredModule; };
        });

        default = { };
        apply = mapAttrs (_: { module, ... }: nixosSystem { modules = [ module ]; });
      };
    };
}
