{ inputs, ... }: {
  flake = flake: {
    modules = {
      nixos.home-manager = { config, username, ... }: {
        imports = [ (inputs.home-manager + "/nixos") ];

        home-manager = {
          extraSpecialArgs = config._module.args // config._module.specialArgs;
          useGlobalPkgs = true;
          useUserPackages = true;
          users.${username} = { };
          sharedModules = [ flake.config.modules.homeManager.nixpkgs ];
        };
      };

      homeManager.nixpkgs = { lib, ... }: { home.stateVersion = lib.trivial.release; };
    };
  };
}
