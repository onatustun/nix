{
  partitions.dev.module.perSystem =
    { pkgs, ... }:
    {
      make-shells.default.packages = [ pkgs.attic-client ];
    };

  flake.modules.homeManager.attic =
    { pkgs, ... }:
    {
      home.packages = [ pkgs.attic-client ];
    };
}
