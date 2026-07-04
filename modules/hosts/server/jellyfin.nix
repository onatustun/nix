{
  flake.nixosConfigurations.server.module = { config, ... }: {
    services.nginx.virtualHosts."jellyfin.${config.networking.domain}" = {
      enableACME = true;
      forceSSL = true;

      locations."/" = {
        proxyPass = "http://desktop:8096";
        proxyWebsockets = true;
      };
    };
  };
}
