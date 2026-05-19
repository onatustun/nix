{
  flake.modules.homeManager.git.programs.git = {
    enable = true;
    lfs.enable = true;

    settings = {
      init.defaultBranch = "main";

      user = {
        email = "git@onatustun.com";
        name = "onatustun";
      };
    };
  };
}
