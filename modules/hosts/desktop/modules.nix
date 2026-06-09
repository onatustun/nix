{
  flake =
    { config, ... }:
    {
      nixosConfigurations.desktop.module =
        { lib, ... }:
        let
          inherit (lib.attrsets) attrValues;
        in
        {
          imports = attrValues {
            inherit (config.modules.nixos)
              bluetooth
              boot
              dms
              fonts
              graphics
              home-manager
              initrd
              keyring
              locale
              networking
              nh
              niri
              nix
              nixpkgs
              nushell
              pipewire
              plymouth
              ragenix
              ssh
              stylix
              tailscale
              thunar
              users
              yubikey
              ;
          };

          home-manager.sharedModules = attrValues {
            inherit (config.modules.homeManager)
              attic
              cursor
              direnv
              ghostty
              git
              github
              helium
              helix
              jujutsu
              media
              nixpkgs
              obsidian
              radicle
              starship
              tmux
              utils
              wayvnc
              wl-clipboard
              xdg
              zoxide
              ;
          };
        };
    };
}
