{
  perSystem =
    { lib, ... }:
    let
      inherit (lib.lists) singleton;
    in
    {
      topology.modules = singleton {
        networks.tailscale = {
          name = "tailscale";
          cidrv4 = "100.64.0.0/10";
        };
      };
    };

  flake =
    { config, ... }@flake:
    {
      secrets.tailscale-authkey = {
        file = ./tailscale-authkey.age;
        publicKeys = config.keys.ssh.hosts { };
      };

      modules.nixos.tailscale = { config, ... }: {
        age.secrets.tailscale-authkey = { inherit (flake.config.secrets.tailscale-authkey) file; };

        services = {
          resolved.settings.Resolve.Domains = [ "~." ];

          tailscale = {
            enable = true;
            authKeyFile = config.age.secrets.tailscale-authkey.path;
            useRoutingFeatures = "both";
            openFirewall = true;
            extraUpFlags = [ "--ssh" ];
            extraSetFlags = [ "--advertise-exit-node" ];
          };
        };

        networking.firewall.trustedInterfaces = [ config.services.tailscale.interfaceName ];

        topology.self.interfaces.tailscale0 = {
          type = "wireguard";
          network = "tailscale";
          virtual = true;
        };
      };
    };
}
