{
  flake = { config, ... }: {
    nixosConfigurations.desktop.module = {
      imports = with config.modules.nixos; [
        audio
        bluetooth
        boot
        dms
        home-manager
        locale
        networking
        niri
        nix
        plymouth
        ragenix
        seahorse
        ssh
        stylix
        tailscale
        thunar
        users
        yubikey
      ];

      home-manager.sharedModules = with config.modules.homeManager; [
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
        nushell
        obsidian
        radicle
        starship
        tmux
        utils
        wayvnc
        wl-clipboard
        xdg
        zoxide
      ];
    };
  };
}
