{
  flake.modules.homeManager.radicle =
    {
      nixosConfig,
      pkgs,
      username,
      ...
    }:
    let
      inherit (nixosConfig.networking) hostName;
    in
    {
      home.packages = [ pkgs.radicle-desktop ];

      programs.radicle = {
        enable = true;

        settings = {
          publicExplorer = "https://explore.seed.onatustun.com/nodes/$host/$rid$path";

          node = {
            alias = "${username}-${hostName}";
            listen = [ "0.0.0.0:8776" ];
            connect = [ "z6Mkq6sSwsAd3nHUNqujqZBga7PoKNDj73bdMHaWtVfDe6L8@seed.onatustun.com:8776" ];
          };
        };
      };
    };
}
