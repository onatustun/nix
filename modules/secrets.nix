{ inputs, ... }:
{
  partitions.dev.module.perSystem =
    { inputs', ... }:
    {
      make-shells.default = {
        shellHook = ''
          export RULES="$(git rev-parse --show-toplevel)/secrets.nix"
        '';

        packages = [ inputs'.ragenix.packages.default ];
      };
    };

  flake = {
    keys = import inputs.keys;

    modules.nixos.ragenix = {
      imports = [ inputs.ragenix.nixosModules.default ];
      _module.args.keys = import inputs.keys;
      home-manager.sharedModules = [ inputs.ragenix.homeManagerModules.default ];
    };
  };
}
