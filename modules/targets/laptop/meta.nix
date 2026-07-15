{
  flake.nixosConfigurations.laptop.module = {
    _module.args.username = "onat";
    networking.hostName = "laptop";
    system.stateVersion = "24.11";
    home-manager.sharedModules = [ { home.stateVersion = "24.11"; } ];
  };
}
