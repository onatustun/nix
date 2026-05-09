{ inputs, moduleWithSystem, ... }:
{
  imports = [ inputs.home-manager.flakeModules.home-manager ];

  partitions.dev.module.perSystem =
    { inputs', ... }:
    {
      make-shells.default.packages = [ inputs'.home-manager.packages.default ];
    };

  flake = flake: {
    modules = {
      nixos.home-manager = moduleWithSystem (
        { inputs', ... }:
        { username, config, ... }:
        {
          imports = [ inputs.home-manager.nixosModules.home-manager ];
          environment.systemPackages = [ inputs'.home-manager.packages.default ];

          home-manager = {
            users.${username}.imports = [ flake.config.modules.homeManager.home-manager ];
            extraSpecialArgs = config._module.args // config._module.specialArgs;
            useUserPackages = true;
            backupFileExtension = "hmBackup";
          };
        }
      );

      homeManager.home-manager =
        {
          username,
          homeDir,
          config,
          ...
        }:
        {
          home = {
            inherit username;
            homeDirectory = homeDir;

            sessionVariables = {
              FLAKE = "${homeDir}/nix";
              NH_FLAKE = config.home.sessionVariables.FLAKE;
            };
          };

          programs.home-manager.enable = true;
        };
    };
  };
}
