{
  flake = flake: {
    configurations.nixos.desktop.module =
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
            nh
            niri
            nix
            nix-index
            nixpkgs
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
            attic
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
            nixpkgs
            noctalia
            obsidian
            radicle
            starship
            swayidle
            tmux
            utils
            wayvnc
            wl-clipboard
            xdg
            xwayland
            zoxide
            zsh
            ;
        };
      };
  };
}
