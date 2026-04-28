{
  flake.modules.homeManager.helix =
    { lib, pkgs, ... }:
    let
      inherit (lib.lists) singleton;
    in
    {
      home.packages = [ pkgs.steel ];

      xdg.configFile = {
        "helix/init.scm".source = ./init.scm;
        "helix/themes/gruber-darker.toml".source = ./gruber-darker.toml;
      };

      programs.helix = {
        package = pkgs.steelix;

        languages = {
          language = singleton {
            name = "scheme";
            language-servers = [ "steel-language-server" ];
          };

          language-server.steel-language-server.command = "steel-language-server";
        };
      };
    };
}
