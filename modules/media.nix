{
  flake.modules.homeManager.media =
    { lib, pkgs, ... }:
    let
      inherit (lib.attrsets) attrValues;
    in
    {
      home.packages = attrValues {
        inherit (pkgs)
          ffmpeg-full
          haruna
          imv
          nicotine-plus
          pavucontrol
          playerctl
          pwvucontrol
          yt-dlp
          ;
      };

      programs.mpv.enable = true;
    };
}
