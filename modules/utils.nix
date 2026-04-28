{
  flake.modules.homeManager.utils =
    { pkgs, ... }:
    {
      home.packages = [
        pkgs.nix-search-cli
        pkgs.noogle-search
      ];

      programs = {
        fd.enable = true;
        ripgrep.enable = true;
        yazi.enable = true;
      };
    };
}
