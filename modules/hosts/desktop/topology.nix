{ inputs, ... }:
{
  flake.configurations.nixos.desktop.module =
    { config, ... }:
    let
      inherit (config.lib.topology) mkConnection;
    in
    {
      imports = [ inputs.nix-topology.nixosModules.default ];

      topology.self.interfaces.eno1 = {
        network = "home";
        physicalConnections = [ (mkConnection "mesh-booster" "eth1") ];
      };
    };
}
