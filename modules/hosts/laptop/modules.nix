{
  flake = flake: {
    configurations.nixos.laptop.module =
      { lib, ... }:
      let
        inherit (lib.attrsets) attrValues;
      in
      {
        imports = attrValues {
          inherit (flake.config.modules.nixos)
            bluetooth
            boot
            fonts
            gdm
            graphics
            home-manager
            initrd
            keyring
            locale
            networking
            niri
            nix
            nix-index
            nixpkgs
            noctalia
            nushell
            pipewire
            plymouth
            printing
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
          inherit (flake.config.modules.homeManager)
            bash
            bat
            carapace
            cursor
            direnv
            eza
            fish
            ghostty
            git
            helium
            helix
            jujutsu
            media
            nh
            nixpkgs
            obsidian
            starship
            swayidle
            tmux
            utils
            wayvnc
            wl-clipboard
            xdg
            xwayland
            zmkbatx
            zoxide
            zsh
            ;
        };
      };
  };
}
