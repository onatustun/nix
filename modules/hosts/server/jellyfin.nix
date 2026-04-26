{
  flake.modules.nixos.jellyfin.services = {
    nginx.virtualHosts."jellyfin.onatustun.com" = {
      enableACME = true;
      forceSSL = true;
      locations."/".proxyPass = "http://127.0.0.1:8096";
    };

    jellyfin = {
      enable = true;
      openFirewall = false;
    };
  };
}
