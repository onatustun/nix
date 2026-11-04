{
  flake.modules.nixos.plymouth.boot = {
    consoleLogLevel = 0;
    plymouth.enable = true;
  };
}
