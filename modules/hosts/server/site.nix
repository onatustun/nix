{
  flake.nixosConfigurations.server.module =
    { config, ... }:
    let
      inherit (config.networking) domain;
    in
    {
      systemd.tmpfiles.rules = [ "d /var/www/${domain} 0755 nginx nginx -" ];
      services.nginx.virtualHosts.${domain}.root = "/var/www/${domain}";
    };
}
