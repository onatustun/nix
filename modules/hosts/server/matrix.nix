{ inputs, ... }:
{
  flake.configurations.nixos.server.module =
    { rootDomain, ... }:
    let
      matrixDomain = "matrix.${rootDomain}";
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

          ${rootDomain} = {
            enableACME = true;
            forceSSL = true;
            locations."/.well-known/matrix/".proxyPass = "http://127.0.0.1:${toString port}";
          };
        };

        matrix-tuwunel = {
          enable = true;

          settings.global = {
            server_name = rootDomain;
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
        icon = inputs.self + "/assets/matrix.svg";
        info = matrixDomain;
      };
    };
}
