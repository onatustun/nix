{
  flake.nixosConfigurations.server.module =
    { rootDomain, ... }:
    {
      services = {
        nginx.virtualHosts."jellyfin.${rootDomain}" = {
          enableACME = true;
          forceSSL = true;
          locations."/".proxyPass = "http://127.0.0.1:8096";
        };

        jellyfin = {
          enable = true;
          openFirewall = false;
        };
      };
    };
}
