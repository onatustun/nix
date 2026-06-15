{
  flake.nixosConfigurations.server.module =
    { config, ... }:
    let
      inherit (config.networking) domain;
    in
    {
      services.nginx.virtualHosts."jellyfin.${domain}" = {
        enableACME = true;
        forceSSL = true;

        locations."/" = {
          proxyPass = "http://desktop:8096";
          proxyWebsockets = true;
        };
      };
    };
}
