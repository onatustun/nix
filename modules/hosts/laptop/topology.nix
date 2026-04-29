{ inputs, ... }:
{
  flake.configurations.nixos.laptop.module =
    { config, ... }:
    let
      inherit (config.lib.topology) mkConnection;
    in
    {
      imports = [ inputs.nix-topology.nixosModules.default ];

      topology.self = {
        hardware.info = "Framework 13";

        interfaces.wlp1s0 = {
          type = "wifi";
          network = "home";
          physicalConnections = [ (mkConnection "router" "wifi") ];
        };
      };
    };
}
