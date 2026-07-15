{ inputs, ... }: {
  flake.modules.nixos.home-manager =
    {
      keys ? { },
      username,
      ...
    }:
    {
      imports = [ (inputs.home-manager.sourceInfo.outPath + "/nixos/default.nix") ];

      home-manager = {
        extraSpecialArgs = { inherit keys username; };
        useGlobalPkgs = true;
        useUserPackages = true;
        users.${username} = { };
      };
    };
}
