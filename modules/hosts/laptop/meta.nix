{
  flake.nixosConfigurations.laptop.module = {
    _module.args.username = "onat";
    networking.hostName = "laptop";
  };
}
