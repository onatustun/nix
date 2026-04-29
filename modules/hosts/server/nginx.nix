{
  flake.configurations.nixos.server.module = {
    networking.firewall = {
      allowedUDPPorts = [ 443 ];

      allowedTCPPorts = [
        443
        80
      ];
    };

    users.groups.certs.members = [ "nginx" ];

    services.nginx = {
      enable = true;
      recommendedGzipSettings = true;
      recommendedOptimisation = true;
      recommendedProxySettings = true;
      recommendedTlsSettings = true;
    };
  };
}
