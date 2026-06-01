{
  flake =
    { config, ... }:
    {
      nixosConfigurations.server.module =
        { lib, ... }:
        let
          inherit (lib.attrsets) attrValues;
        in
        {
          imports = attrValues {
            inherit (config.modules.nixos)
              home-manager
              locale
              networking
              nh
              nix
              nixpkgs
              ragenix
              ssh
              tailscale
              users
              ;
          };

          home-manager.sharedModules = [
            config.modules.homeManager.nixpkgs
            config.modules.homeManager.xdg
          ];
        };
    };
}
