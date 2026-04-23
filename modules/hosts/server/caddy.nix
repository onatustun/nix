{
  flake.modules.nixos.caddy = {
    users.groups.certs.members = [ "caddy" ];

    networking.firewall.allowedTCPPorts = [
      80
      443
    ];

    services.caddy.enable = true;
  };
}
