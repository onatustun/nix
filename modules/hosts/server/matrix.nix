{ inputs, ... }: {
  flake.nixosConfigurations.server.module =
    { config, ... }:
    let
      inherit (config.networking) domain;
      matrixDomain = "matrix.${domain}";
      port = 6167;
    in
    {
      networking.firewall.allowedTCPPorts = [ 8448 ];

      services = {
        nginx.virtualHosts = {
          ${matrixDomain} = {
            enableACME = true;
            forceSSL = true;
            locations."/".proxyPass = "http://127.0.0.1:${toString port}";

            listen = [
              {
                addr = "0.0.0.0";
                port = 80;
              }
              {
                addr = "[::0]";
                port = 80;
              }
              {
                addr = "0.0.0.0";
                port = 443;
                ssl = true;
              }
              {
                addr = "[::0]";
                port = 443;
                ssl = true;
              }
              {
                addr = "0.0.0.0";
                port = 8448;
                ssl = true;
              }
              {
                addr = "[::0]";
                port = 8448;
                ssl = true;
              }
            ];
          };

          ${domain} = {
            enableACME = true;
            forceSSL = true;
            locations."/.well-known/matrix/".proxyPass = "http://127.0.0.1:${toString port}";
          };
        };

        matrix-tuwunel = {
          enable = true;

          settings.global = {
            server_name = domain;
            port = [ port ];

            well_known = {
              client = "https://${matrixDomain}";
              server = "${matrixDomain}:443";
            };
          };
        };
      };

      topology.self.services.tuwunel = {
        name = "Tuwunel Matrix";
        icon = inputs.self.sourceInfo.outPath + "/assets/matrix.svg";
        info = matrixDomain;
      };
    };
}
