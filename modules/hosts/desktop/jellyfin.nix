{
  flake.nixosConfigurations.desktop.module =
    { config, homeDir, ... }:
    let
      service = "jellyfin";
      cfg = config.services.${service};
      mediaDir = "/srv/media";
      musicDir = "${mediaDir}/music";
      mode = "0755";
    in
    {
      services.${service}.enable = true;

      systemd.tmpfiles.settings.${service} = {
        ${mediaDir}.d = {
          inherit mode;
          inherit (cfg) user group;
        };

        ${musicDir}.d = {
          inherit mode;
          inherit (cfg) user group;
        };
      };

      fileSystems.${musicDir} = {
        device = "${homeDir}/Music";
        fsType = "none";
        options = [ "bind" ];
      };
    };
}
