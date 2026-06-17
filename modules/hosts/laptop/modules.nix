{
  flake = { config, ... }: {
    nixosConfigurations.laptop.module = {
      imports = with config.modules.nixos; [
        audio
        bluetooth
        boot
        dms
        home-manager
        locale
        networking
        nh
        niri
        nix
        nixpkgs
        nushell
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
        obsidian
        radicle
        starship
        tmux
        utils
        wayvnc
        wl-clipboard
        xdg
        zmkbatx
        zoxide
      ];
    };
  };
}
