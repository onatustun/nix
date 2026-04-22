{ inputs, moduleWithSystem, ... }:
{
  partitions.dev.module.perSystem =
    { inputs', ... }:
    {
      make-shells.default = {
        shellHook = ''
          export RULES="$(git rev-parse --show-toplevel)/secrets.nix"
        '';

        packages = [ inputs'.agenix.packages.default ];
      };
    };

  flake =
    { config, ... }:
    {
      keys = import inputs.keys;

      modules = {
        nixos = {
          core._module.args.keys = import inputs.keys;

          agenix = {
            imports = [ inputs.agenix.nixosModules.default ];
            age.identityPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
            home-manager.sharedModules = [ config.modules.homeManager.agenix ];
          };
        };

        homeManager.agenix = moduleWithSystem (
          { inputs', ... }:
          { config, ... }:
          {
            imports = [ inputs.agenix.homeManagerModules.default ];
            age.identityPaths = [ "${config.home.homeDirectory}/.ssh/id_ed25519" ];
            home.packages = [ inputs'.agenix.packages.default ];
          }
        );
      };
    };
}
