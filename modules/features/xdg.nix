{
  flake.modules.homeManager.xdg = {
    home.preferXdgDirectories = true;

    xdg = {
      enable = true;
      mimeApps.enable = true;

      userDirs = {
        enable = true;
        createDirectories = true;
        setSessionVariables = false;
      };
    };
  };
}
