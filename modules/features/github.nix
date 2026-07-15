{
  flake.modules.homeManager.github.programs.gh = {
    enable = true;
    settings.git_protocol = "ssh";
  };
}
