{ inputs, config, ... }: {
  imports = [ (inputs.nix-topology.sourceInfo.outPath + "/flake-module.nix") ];

  perSystem =
    { lib, ... }:
    let
      inherit (lib.lists) singleton;
    in
    {
      topology = {
        inherit (config.flake) nixosConfigurations;

        modules = singleton (
          { config, ... }:
          let
            inherit (config.lib.topology) mkInternet mkConnection mkRouter;
          in
          {
            nodes = {
              internet = mkInternet { connections = mkConnection "router" "wan"; };

              router = mkRouter "Vodafone WiFi" {
                info = "Home Gateway";

                interfaceGroups = singleton [
                  "lan1"
                  "wan"
                ];

                interfaces = {
                  wan = { };
                  lan1.network = "home";
                  wifi.network = "home";
                };

                connections.lan1 = mkConnection "mesh-booster" "uplink";
              };

              mesh-booster = {
                name = "Mesh WiFi Booster";
                deviceType = "switch";

                interfaces = {
                  uplink = {
                    network = "home";
                    physicalConnections = [ (mkConnection "router" "lan1") ];
                  };

                  eth1 = {
                    network = "home";
                    physicalConnections = [ (mkConnection "desktop" "eno1") ];
                  };
                };
              };
            };

            networks.home = {
              name = "home network";
              cidrv4 = "192.168.1.0/24";
            };
          }
        );
      };
    };
}
