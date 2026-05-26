{ inputs, ... }:
{
  flake = flake: {
    modules = {
      nixos.home-manager =
        { username, config, ... }:
        {
          imports = [ (inputs.home-manager + "/nixos") ];

          home-manager = {
            users.${username}.imports = [ flake.config.modules.homeManager.home-manager ];
            extraSpecialArgs = config._module.args // config._module.specialArgs;
            useUserPackages = true;
            backupFileExtension = "hmBackup";
          };
        };

      homeManager.home-manager =
        { username, homeDir, ... }:
        {
          home = {
            inherit username;
            homeDirectory = homeDir;
          };

          programs.home-manager.enable = true;
        };
    };
  };
}
