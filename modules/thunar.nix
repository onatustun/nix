{
  flake = { config, ... }: {
    modules = {
      nixos.thunar = { pkgs, ... }: {
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

        home-manager.sharedModules = [ config.modules.homeManager.thunar ];
      };

      homeManager.thunar = { pkgs, ... }: {
        home.packages = with pkgs; [
          ffmpegthumbnailer
          kdePackages.ark
          libgsf
        ];

        services.udiskie.enable = true;
        xdg.mimeApps.defaultApplications."inode/directory" = "thunar.desktop";
      };
    };
  };
}
