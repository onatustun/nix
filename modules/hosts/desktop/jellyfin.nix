{
  flake.nixosConfigurations.desktop.module =
    { config, username, ... }:
    let
      mediaDir = "/srv/media";
      musicDir = "${mediaDir}/music";
      mode = "0755";
      cfg = config.services.jellyfin;
      inherit (config.users.users.${username}) home;
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
        device = "${home}/Music";
        fsType = "none";
        options = [ "bind" ];
      };
    };
}
