{
  flake.nixosConfigurations.server.module = {
    _module.args.username = "onat";
    system.stateVersion = "26.05";
  };
}
