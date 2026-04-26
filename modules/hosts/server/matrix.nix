{ inputs, ... }:
{
  flake.modules.nixos.matrix =
    let
      server_name = "onatustun.com";
      matrixDomain = "matrix.${server_name}";
      port = 6167;
    in
    {
      networking.firewall.allowedTCPPorts = [ 8448 ];

      services = {
        nginx.virtualHosts = {
          ${matrixDomain} = {
            enableACME = true;
            forceSSL = true;
            locations."/".proxyPass = "http://localhost:${toString port}";

            listen = [
              {
                addr = "0.0.0.0";
                port = 443;
                ssl = true;
              }
              {
                addr = "0.0.0.0";
                port = 8448;
                ssl = true;
              }
            ];
          };

          ${server_name} = {
            enableACME = true;
            forceSSL = true;
            locations."/.well-known/matrix/".proxyPass = "http://localhost:${toString port}";
          };
        };

        matrix-tuwunel = {
          enable = true;

          settings.global = {
            inherit server_name;
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
