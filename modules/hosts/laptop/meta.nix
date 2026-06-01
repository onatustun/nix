{
  flake.nixosConfigurations.laptop.module._module.args = {
    hostName = "laptop";
    username = "onat";
  };
}
