{
  flake.modules.homeManager.xdg = {
    home.preferXdgDirectories = true;

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
