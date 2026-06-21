{
  flake.nixosConfigurations.server.module =
    { config, ... }:
    let
      inherit (config.networking) domain;
      root = "/var/www/${domain}";
    in
    {
      systemd.tmpfiles.rules = [ "d ${root} 0755 nginx nginx -" ];
      services.nginx.virtualHosts.${domain} = { inherit root; };
    };
}
