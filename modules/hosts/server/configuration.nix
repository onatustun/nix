{ inputs, ... }:
{
  flake =
    { lib, config, ... }:
    let
      inherit (lib) nixosSystem;
      inherit (lib.lists) singleton;
    in
    {
      nixosConfigurations.server = nixosSystem {
        modules = singleton (
          {
            lib,
            modulesPath,
            keys,
            username,
            ...
          }:
          let
            inherit (lib.attrsets) attrValues;
          in
          {
            imports =
              attrValues {
                inherit (config.modules.nixos)
                  agenix
                  core
                  home-manager
                  locale
                  networking
                  nix
                  ssh
                  tailscale
                  users
                  ;
              }
              ++ [
                config.diskoConfigurations.server
                inputs.disko.nixosModules.disko
                inputs.nix-topology.nixosModules.default
                (modulesPath + "/profiles/qemu-guest.nix")
              ];

            _module.args = {
              hostName = "server";
              username = "onat";
            };

            nixpkgs.hostPlatform.system = "x86_64-linux";

            boot = {
              loader.grub = {
                enable = true;
                efiSupport = false;
              };

              initrd.availableKernelModules = [
                "ata_piix"
                "uhci_hcd"
                "virtio_pci"
                "sr_mod"
                "virtio_blk"
              ];
            };

            topology.self.hardware.info = "Netcup VPS";

            users.users = {
              root.openssh.authorizedKeys.keys = keys.ssh.users.admins;

              ${username} = {
                openssh.authorizedKeys.keys = keys.ssh.users.admins;
                extraGroups = [ "wheel" ];
              };
            };

            networking.firewall = {
              enable = true;

              allowedTCPPorts = [
                80
                443
              ];
            };

            services = {
              caddy = {
                enable = true;
                virtualHosts."jellyfin.onatustun.com".extraConfig = "reverse_proxy localhost:8096";
              };

              jellyfin = {
                enable = true;
                openFirewall = false;
              };
            };

            home-manager.sharedModules = [ config.modules.homeManager.xdg ];
          }
        );
      };
    };
}
