{ inputs, ... }: {
  flake = { config, ... }: {
    modules = {
      nixos.home-manager = { keys, username, ... }: {
        imports = [ (inputs.home-manager + "/nixos") ];

        home-manager = {
          extraSpecialArgs = { inherit keys username; };
          useGlobalPkgs = true;
          useUserPackages = true;
          users.${username} = { };
          sharedModules = [ config.modules.homeManager.nixpkgs ];
        };
      };

      homeManager.nixpkgs = { lib, ... }: { home.stateVersion = lib.trivial.release; };
    };
  };
}
