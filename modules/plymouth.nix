{
  flake.modules.nixos.plymouth.boot = {
    consoleLogLevel = 0;
    initrd.verbose = false;
    plymouth.enable = true;
  };
}
