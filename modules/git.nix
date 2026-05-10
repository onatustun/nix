{
  flake.modules.homeManager.git.programs.git = {
    enable = true;
    lfs.enable = true;

    settings = {
      commit.verbose = true;

      user = {
        email = "git@onatustun.com";
        name = "onatustun";
      };
    };
  };
}
