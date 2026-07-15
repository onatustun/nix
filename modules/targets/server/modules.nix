{
  flake = { config, ... }: {
    nixosConfigurations.server.module.imports = with config.modules.nixos; [
      locale
      networking
      nix
      ragenix
      ssh
      tailscale
      users
    ];
  };
}
