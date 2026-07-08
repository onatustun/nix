{ inputs, ... }: {
  flake.nixosConfigurations.server.module =
    {
      lib,
      config,
      pkgs,
      keys,
      ...
    }:
    let
      inherit (lib.lists) singleton;
      rootDomain = config.networking.domain;
      domain = "seed.${rootDomain}";
      explore = "explore.${domain}";
    in
    {
      age.secrets.radicle-private-key = {
        file = ./radicle-private-key.age;
        group = config.users.groups.radicle.name;
        owner = config.users.users.radicle.name;
      };

      services = {
        nginx.virtualHosts.${explore} = {
          enableACME = true;
          forceSSL = true;

          locations."/" = {
            root = pkgs.radicle-explorer.withConfig {
              nodes.fallbackPublicExplorer = "https://${explore}/nodes/$host/$rid$path";

              preferredSeeds = singleton {
                hostname = domain;
                port = 443;
                scheme = "https";
              };
            };

            extraConfig = "try_files $uri $uri/ /index.html;";
          };
        };

        radicle = {
          enable = true;
          publicKey = keys.radicle.server;
          privateKey = config.age.secrets.radicle-private-key.path;
          node.openFirewall = true;

          httpd = {
            enable = true;

            nginx = {
              enableACME = true;
              forceSSL = true;
              serverName = domain;
            };
          };

          settings = {
            node.seedingPolicy.default = "block";
            publicExplorer = "https://${explore}/nodes/$host/$rid$path";

            web = {
              description = "https://${rootDomain}";
              pinned.repositories = [ ];
            };
          };
        };
      };

      systemd.services.radicle-node.serviceConfig.BindReadOnlyPaths = [
        "${config.age.secrets.radicle-private-key.path}:/var/lib/radicle/keys/radicle"
      ];

      topology.self.services = {
        radicle = {
          name = "Radicle Seed Node";
          icon = inputs.self.sourceInfo.outPath + "/assets/radicle.svg";
          info = domain;
        };

        radicle-explorer = {
          name = "Radicle Explorer";
          icon = inputs.self.sourceInfo.outPath + "/assets/radicle.svg";
          info = explore;
        };
      };
    };
}
