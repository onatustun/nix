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
        caddy = {
          extraConfig = ''
            :8448 {
              reverse_proxy localhost:${toString port}
            }
          '';

          virtualHosts = {
            ${matrixDomain}.extraConfig = ''
              reverse_proxy localhost:${toString port}
            '';

            "https://${server_name}".extraConfig = ''
              handle /.well-known/matrix/* {
                reverse_proxy localhost:${toString port}
              }
            '';
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
