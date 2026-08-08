{
  flake.modules.homeManager.media =
    { lib, pkgs, ... }:
    let
      inherit (lib.trivial) flip const;
      inherit (lib.attrsets) genAttrs;
    in
    {
      home.packages = with pkgs; [
        ffmpeg-full
        haruna
      ];

      programs = {
        imv.enable = true;
        zathura.enable = true;
      };

      xdg.mimeApps.defaultApplications = flip genAttrs (const "imv.desktop") [
        "image/gif"
        "image/jpeg"
        "image/png"
      ];
    };
}
