{
  flake.nixosConfigurations.desktop.module =
    { config, homeDir, ... }:
    let
      mediaDir = "/srv/media";
      musicDir = "${mediaDir}/music";
      mode = "0755";
      cfg = config.services.jellyfin;
    in
    {
      services.jellyfin.enable = true;

      systemd.tmpfiles.settings.jellyfin = {
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
