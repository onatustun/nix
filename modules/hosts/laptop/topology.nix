{ inputs, ... }: {
  flake.nixosConfigurations.laptop.module =
    { config, ... }:
    let
      inherit (config.lib.topology) mkConnection;
    in
    {
      imports = [ (inputs.nix-topology + "/nixos/module.nix") ];

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
