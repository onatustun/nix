{
  flake.nixosConfigurations.desktop.module = {
    _module.args.username = "onat";
    networking.hostName = "desktop";
    system.stateVersion = "24.11";
    home-manager.sharedModules = [ { home.stateVersion = "24.11"; } ];
  };
}
