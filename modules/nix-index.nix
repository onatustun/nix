{ inputs, ... }:
{
  flake.modules.nixos.nix-index =
    { lib, ... }:
    let
      inherit (lib.modules) mkForce;
    in
    {
      imports = [ inputs.nix-index-database.nixosModules.default ];

      programs = {
        nix-index-database.comma.enable = true;
        command-not-found.enable = mkForce false;
      };

      home-manager.sharedModules = [ inputs.nix-index-database.homeModules.default ];
    };
}
