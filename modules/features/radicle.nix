{
  flake.modules.homeManager.radicle =
    {
      pkgs,
      username,
      nixosConfig,
      ...
    }:
    {
      home.packages = with pkgs; [ radicle-desktop ];

      programs.radicle = {
        enable = true;

        settings = {
          publicExplorer = "https://explore.seed.onatustun.com/nodes/$host/$rid$path";

          node = {
            alias = "${username}-${nixosConfig.networking.hostName}";
            listen = [ "0.0.0.0:8776" ];
            connect = [ "z6Mkq6sSwsAd3nHUNqujqZBga7PoKNDj73bdMHaWtVfDe6L8@seed.onatustun.com:8776" ];
          };
        };
      };
    };
}
