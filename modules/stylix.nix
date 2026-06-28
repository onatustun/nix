{ inputs, ... }: {
  flake.modules.nixos.stylix =
    { lib, pkgs, ... }:
    let
      inherit (pkgs) runCommand;
      inherit (lib.meta) getExe;
      inherit (lib.lists) singleton;

      base16 =
        import
        <|
          runCommand "base16-to-nix" { nativeBuildInputs = with pkgs; [ yaml2nix ]; }
            "${getExe pkgs.yaml2nix} ${
              pkgs.base16-schemes.outPath + "/share/themes/catppuccin-mocha.yaml"
            } > $out";
    in
    {
      imports = [ inputs.stylix.nixosModules.stylix ];

      stylix = {
        enable = true;
        polarity = base16.variant;

        base16Scheme = base16.palette // {
          name = "catppuccin_mocha";
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

      home-manager.sharedModules = singleton (
        { config, ... }: {
          stylix.targets = {
            helix.enable = false;
            tmux.enable = false;
          };

          programs.helix.settings.theme = config.stylix.base16Scheme.name;
        }
      );
    };
}
