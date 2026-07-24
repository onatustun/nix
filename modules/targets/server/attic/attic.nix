{
  flake =
    { config, ... }@flake:
    {
      secrets.attic-env = {
        file = ./attic-env.age;
        publicKeys = config.keys.ssh.hosts { };
      };

      nixosConfigurations.server.module =
        { lib, config, ... }:
        let
          inherit (lib.lists) singleton;
          domain = "cache.${config.networking.domain}";
        in
        {
          age.secrets.attic-env = { inherit (flake.config.secrets.attic-env) file; };

          services = {
            nginx.virtualHosts.${domain} = {
              enableACME = true;
              forceSSL = true;

              locations."/" = {
                proxyPass = "http://${config.services.atticd.settings.listen}";
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
                allowed-hosts = [ domain ];
                api-endpoint = "https://${domain}/";
                compression.type = "zstd";
                database.url = "postgresql://atticd@localhost/atticd?host=/run/postgresql";
                listen = "127.0.0.1:8081";

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
    };
}
