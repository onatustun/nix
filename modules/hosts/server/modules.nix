{
  flake =
    { config, ... }:
    {
      configurations.nixos.server.module =
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
