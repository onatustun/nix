{ inputs, ... }: {
  flake.modules.nixos.home-manager = { keys, username, ... }: {
    imports = [ (inputs.home-manager.outPath + "/nixos") ];

    home-manager = {
      extraSpecialArgs = { inherit keys username; };
      useGlobalPkgs = true;
      useUserPackages = true;
      users.${username} = { };
      sharedModules = [ ({ lib, ... }: { home.stateVersion = lib.trivial.release; }) ];
    };
  };
}
