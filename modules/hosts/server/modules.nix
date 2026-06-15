{
  flake = { config, ... }: {
    nixosConfigurations.server.module.imports = with config.modules.nixos; [
      locale
      networking
      nh
      nix
      nixpkgs
      ragenix
      ssh
      tailscale
      users
    ];
  };
}
