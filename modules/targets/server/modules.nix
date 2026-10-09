{
  flake = { config, ... }: {
    nixosConfigurations.server.module.imports = with config.modules.nixos; [
      agenix
      locale
      networking
      nix
      ssh
      tailscale
      users
    ];
  };
}
