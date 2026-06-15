{ inputs, ... }: {
  flake.nixosConfigurations.desktop.module =
    { config, ... }:
    let
      inherit (config.lib.topology) mkConnection;
    in
    {
      imports = [ (inputs.nix-topology + "/nixos/module.nix") ];

      topology.self.interfaces.eno1 = {
        network = "home";
        physicalConnections = [ (mkConnection "mesh-booster" "eth1") ];
      };
    };
}
