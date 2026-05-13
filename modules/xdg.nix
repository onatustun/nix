{
  flake.modules.homeManager.xdg =
    { pkgs, ... }:
    {
      home = {
        preferXdgDirectories = true;
        packages = [ pkgs.xdg-user-dirs ];
      };

      xdg = {
        enable = true;
        mimeApps.enable = true;
        configFile."mimeapps.list".force = true;

        userDirs = {
          enable = true;
          createDirectories = true;
        };
      };
    };
}
