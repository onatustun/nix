{
  flake.nixosConfigurations.server.module =
    { lib, config, ... }:
    let
      inherit (lib.lists) singleton;
      rootDomain = config.networking.domain;
      domain = "cache.${rootDomain}";
      listen = "127.0.0.1:8081";
    in
    {
      age.secrets.attic-env = {
        file = ./attic-env.age;
        mode = "0400";
      };

      services = {
        nginx.virtualHosts.${domain} = {
          enableACME = true;
          forceSSL = true;

          locations."/" = {
            proxyPass = "http://${listen}";
            extraConfig = "client_max_body_size 0;";
          };
        };

        postgresql = {
          ensureDatabases = [ "atticd" ];

          ensureUsers = singleton {
            name = "atticd";
            ensureDBOwnership = true;
          };
        };

        atticd = {
          enable = true;
          environmentFile = config.age.secrets.attic-env.path;

          settings = {
            inherit listen;
            allowed-hosts = [ domain ];
            api-endpoint = "https://${domain}/";
            database.url = "postgresql:///atticd?host=/run/postgresql";
            compression.type = "zstd";

            garbage-collection = {
              interval = "12 hours";
              default-retention-period = "3 months";
            };
          };
        };
      };

      topology.self.services.attic = {
        name = "Attic Binary Cache";
        icon = "devices.nixos";
        info = domain;
      };
    };
}
