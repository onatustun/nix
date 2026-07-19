{ inputs, ... }: {
  flake.modules.nixos.stylix =
    { pkgs, lib, ... }:
    let
      inherit (pkgs) runCommand;
      inherit (lib.meta) getExe;

      base16 =
        import
        <|
          runCommand "base16-to-nix" { nativeBuildInputs = with pkgs; [ yaml2nix ]; }
            "${getExe pkgs.yaml2nix} ${
              pkgs.base16-schemes.outPath + "/share/themes/gruvbox-dark-hard.yaml"
            } > $out";
    in
    {
      imports = [ inputs.stylix.nixosModules.stylix ];

      stylix = {
        enable = true;
        polarity = base16.variant;

        base16Scheme = base16.palette // {
          name = "gruvbox_dark_hard";
        };

        fonts = {
          sizes.terminal = 14;

          monospace = {
            package = pkgs.nerd-fonts.jetbrains-mono;
            name = "JetBrainsMono Nerd Font Mono";
          };
        };

        cursor = {
          package = pkgs.bibata-cursors;
          name = "Bibata-Modern-Ice";
          size = 24;
        };

        icons = {
          enable = true;
          package = pkgs.adwaita-icon-theme;
          dark = "Adwaita";
          light = "Adwaita";
        };
      };

      fonts.packages = with pkgs; [
        font-awesome
        nerd-fonts.symbols-only
      ];
    };
}
