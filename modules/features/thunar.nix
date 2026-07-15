{
  flake.modules.nixos.thunar =
    { lib, pkgs, ... }:
    let
      inherit (lib.lists) singleton;
    in
    {
      programs.thunar = {
        enable = true;

        plugins = with pkgs; [
          thunar-archive-plugin
          thunar-media-tags-plugin
          thunar-volman
        ];
      };

      services = {
        gvfs.enable = true;
        tumbler.enable = true;
      };

      home-manager.sharedModules = singleton (
        { pkgs, ... }: {
          home.packages = with pkgs; [
            ffmpegthumbnailer
            kdePackages.ark
            libgsf
          ];

          services.udiskie.enable = true;
          xdg.mimeApps.defaultApplications."inode/directory" = "thunar.desktop";
        }
      );
    };
}
