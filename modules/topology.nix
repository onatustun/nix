{
  inputs,
  config,
  lib,
  ...
}:
let
  inherit (lib.lists) singleton;
in
{
  imports = [ inputs.nix-topology.flakeModules.default ];

  perSystem.topology = {
    inherit (config.flake) nixosConfigurations;

    modules = singleton {
      networks.home = {
        name = "home network";
        cidrv4 = "192.168.1.0/24";
      };
    };
  };
}
