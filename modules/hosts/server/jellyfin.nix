{
  flake.nixosConfigurations.server.module =
    { rootDomain, ... }:
    {
      services.nginx.virtualHosts."jellyfin.${rootDomain}" = {
        enableACME = true;
        forceSSL = true;

        locations."/" = {
          proxyPass = "http://desktop:8096";
          proxyWebsockets = true;
        };
      };
    };
}
