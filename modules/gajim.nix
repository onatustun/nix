{
  flake.modules.homeManager.gajim =
    { pkgs, ... }:
    {
      home.packages = [ pkgs.gajim ];
    };
}
