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
        backupFileExtension = "hmBackup";
        extraSpecialArgs = { inherit keys username; };
        overwriteBackup = true;
        useGlobalPkgs = true;
        users.${username} = { };
        useUserPackages = true;
      };
    };
}
