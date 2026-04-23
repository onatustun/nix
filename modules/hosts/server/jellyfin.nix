{
  flake.modules.nixos.jellyfin.services = {
    caddy.virtualHosts."jellyfin.onatustun.com".extraConfig = "reverse_proxy localhost:8096";

    jellyfin = {
      enable = true;
      openFirewall = false;
    };
  };
}
