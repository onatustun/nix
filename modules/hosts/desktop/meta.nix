{
  flake.nixosConfigurations.desktop.module = {
    _module.args.username = "onat";
    networking.hostName = "desktop";
    system.stateVersion = "24.11";
  };
}
