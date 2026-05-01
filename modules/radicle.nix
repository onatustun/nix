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

        settings = {
          publicExplorer = "https://explore.seed.onatustun.com/nodes/$host/$rid$path";

          node = {
            alias = "${username}-${hostName}";
            connect = [ "z6Mkq6sSwsAd3nHUNqujqZBga7PoKNDj73bdMHaWtVfDe6L8@seed.onatustun.com:8776" ];
          };
        };
      };
    };
}
