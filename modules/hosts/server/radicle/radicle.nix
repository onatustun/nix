{ inputs, ... }:
{
  flake.configurations.nixos.server.module =
    {
      lib,
      rootDomain,
      pkgs,
      config,
      keys,
      ...
    }:
    let
      inherit (lib.lists) singleton;
      domain = "seed.${rootDomain}";
      explore = "explore.${domain}";
    in
    {
      age.secrets.private-key = {
        file = ./private-key.age;
        owner = "radicle";
        group = "radicle";
        mode = "0400";
      };

      environment.systemPackages = [ pkgs.radicle-node ];

      system.activationScripts.radicle-setup = {
        deps = [ "agenix" ];

        text = ''
          install -m 600 -o radicle -g radicle \
            ${config.services.radicle.privateKey} /var/lib/radicle/keys/radicle
          install -m 644 -o radicle -g radicle \
            ${config.services.radicle.configFile} /var/lib/radicle/config.json
        '';
      };

      services = {
        nginx.virtualHosts = {
          ${domain} = {
            enableACME = true;
            forceSSL = true;
            locations."/".proxyPass = "http://127.0.0.1:8080";
          };

          ${explore} = {
            enableACME = true;
            forceSSL = true;

            locations."/" = {
              root = pkgs.radicle-explorer.withConfig {
                preferredSeeds = singleton {
                  hostname = domain;
                  port = 443;
                  scheme = "https";
                };
              };

              extraConfig = "try_files $uri $uri/ /index.html;";
            };
          };
        };

        radicle = {
          enable = true;
          publicKey = keys.radicle.server;
          privateKey = config.age.secrets.private-key.path;
          httpd.enable = true;
          node.openFirewall = true;

          settings = {
            publicExplorer = "https://${explore}/nodes/$host/$rid$path";

            node = {
              alias = "onat";
              externalAddresses = [ "${domain}:8776" ];
              seedingPolicy.default = "block";
            };
          };
        };
      };

      topology.self.services = {
        radicle = {
          name = "Radicle Seed Node";
          icon = inputs.self + "/assets/radicle.svg";
          info = domain;
        };

        radicle-explorer = {
          name = "Radicle Explorer";
          icon = inputs.self + "/assets/radicle.svg";
          info = explore;
        };
      };
    };
}
