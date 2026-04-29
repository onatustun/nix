{
  partitions.dev.module.perSystem =
    { pkgs, ... }:
    {
      make-shells.default.packages = [ pkgs.radicle-node ];
    };

  flake.modules.homeManager.radicle =
    {
      pkgs,
      username,
      hostName,
      ...
    }:
    {
      home.packages = [
        pkgs.radicle-desktop
        pkgs.radicle-tui
      ];

      programs.radicle = {
        enable = true;
        settings.node.alias = "${username}-${hostName}";
      };
    };
}
