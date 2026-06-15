{
  flake.nixosConfigurations.server.module.networking = {
    domain = "onatustun.com";
    hostName = "server";
  };
}
