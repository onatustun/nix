{
  flake.nixosConfigurations.desktop.module =
    { config, username, ... }:
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
        device = "${config.users.users.${username}.home}/Music";
        fsType = "none";
        options = [ "bind" ];
      };
    };
}
