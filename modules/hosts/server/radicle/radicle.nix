{ inputs, ... }:
{
  flake.configurations.nixos.server.module =
    {
      rootDomain,
      pkgs,
      keys,
      config,
      ...
    }:
    let
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
              root = pkgs.radicle-explorer;
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
