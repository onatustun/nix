{ inputs, ... }:
{
  flake =
    { config, ... }:
    {
      configurations.nixos.server.module =
        { lib, username, ... }:
        let
          inherit (lib.attrsets) attrValues;
        in
        {
          imports =
            attrValues {
              inherit (config.modules.nixos)
                acme
                home-manager
                jellyfin
                locale
                matrix
                networking
                nginx
                nix
                nixpkgs
                ragenix
                ssh
                tailscale
                users
                xmpp
                ;
            }
            ++ [
              config.diskoConfigurations.server
              inputs.disko.nixosModules.default
              inputs.nix-topology.nixosModules.default
            ];

          _module.args = {
            hostName = "server";
            username = "onat";
          };

          boot.loader.grub = {
            enable = true;
            efiSupport = false;
          };

          hardware.facter.reportPath = ./facter.json;
          topology.self.hardware.info = "Netcup VPS";
          users.users.${username}.extraGroups = [ "wheel" ];
          networking.firewall.enable = true;

          home-manager.sharedModules = [
            config.modules.homeManager.nixpkgs
            config.modules.homeManager.xdg
          ];
        };
    };
}
