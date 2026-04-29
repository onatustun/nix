{
  flake.configurations.nixos.server.module.boot.loader.grub = {
    enable = true;
    efiSupport = false;
  };
}
