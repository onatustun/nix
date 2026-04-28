{
  partitions.dev.module.perSystem =
    { pkgs, ... }:
    {
      make-shells.default.packages = [ pkgs.vim ];
    };

  flake.modules.homeManager.cli =
    { pkgs, ... }:
    {
      home.packages = [
        pkgs.nix-search-cli
        pkgs.noogle-search
      ];

      programs = {
        fd.enable = true;
        ripgrep.enable = true;
        vim.enable = true;
      };
    };
}
