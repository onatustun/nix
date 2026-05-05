{
  flake.configurations.nixos.server.module =
    { rootDomain, ... }:
    {
      systemd.tmpfiles.rules = [ "d /var/www/onatustun.com 0755 nginx nginx -" ];
      services.nginx.virtualHosts.${rootDomain}.root = "/var/www/onatustun.com";
    };
}
