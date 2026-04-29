{
  flake.configurations.nixos.server.module._module.args = {
    hostName = "server";
    username = "onat";
    rootDomain = "onatustun.com";
  };
}
