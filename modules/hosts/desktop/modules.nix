{
  flake = { config, ... }: {
    nixosConfigurations.desktop.module = {
      imports = with config.modules.nixos; [
        bluetooth
        boot
        dms
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
