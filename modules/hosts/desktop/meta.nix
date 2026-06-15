{
  flake.nixosConfigurations.desktop.module = {
    _module.args.username = "onat";
    networking.hostName = "desktop";
  };
}
