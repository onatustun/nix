{
  flake.nixosConfigurations.desktop.module.services.jellyfin = {
    enable = true;
    openFirewall = false;
  };
}
