{ inputs, ... }:
{
  flake = flake: {
    nixosConfigurations.server.module =
      { config, rootDomain, ... }:
      let
        cfg = config.services.calibre-web;
        inherit (cfg.listen) ip port;
        domain = "books.${rootDomain}";
      in
      {
        imports = [ flake.config.modules.nixos.calibre-web ];
        disabledModules = [ "services/web-apps/calibre-web.nix" ];

        services = {
          nginx.virtualHosts.${domain} = {
            enableACME = true;
            forceSSL = true;
            extraConfig = "large_client_header_buffers 4 16k;";

            locations."/" = {
              proxyPass = "http://${ip}:${toString port}";

              extraConfig = ''
                client_max_body_size    0;
                proxy_set_header        X-Forwarded-Proto https;
                proxy_set_header        X-Scheme https;
                proxy_buffer_size       128k;
                proxy_buffers           4 256k;
                proxy_busy_buffers_size 256k;
              '';
            };
          };

          calibre-web = {
            enable = true;
            listen.ip = "127.0.0.1";

            options = {
              calibreLibrary = "/var/lib/calibre-web/library";
              enableBookConversion = true;
              enableBookUploading = true;
              enableKepubify = true;
              enableMetadata = true;

              kobo = {
                enableSync = true;
                externalPort = 443;
                trustedProxy = domain;
              };
            };
          };
        };

        topology.self.services.calibre-web = {
          name = "Calibre Web";
          icon = inputs.self + "/assets/calibre.svg";
          info = domain;
        };
      };
  };
}
