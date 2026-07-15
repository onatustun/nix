{
  flake.modules.homeManager.attic = { pkgs, ... }: { home.packages = with pkgs; [ attic-client ]; };
}
