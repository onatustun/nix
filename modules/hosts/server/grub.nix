{
  flake.nixosConfigurations.server.module.boot.loader.grub = {
    enable = true;
    efiSupport = false;
  };
}
