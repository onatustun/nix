{ moduleWithSystem, ... }: {
  perSystem = { pkgs, ... }: { make-shells.default.packages = with pkgs; [ nixd ]; };

  flake.modules.homeManager.helix = moduleWithSystem (
    { inputs' }:
    { lib, config, ... }:
    let
      inherit (lib.meta) getExe;
    in
    {
      stylix.targets.helix.enable = false;

      home.sessionVariables = {
        EDITOR = getExe config.programs.helix.package;
        VISUAL = config.home.sessionVariables.EDITOR;
      };

      programs.helix = {
        enable = true;
        package = inputs'.helix.packages.default;

        settings = {
          theme = config.stylix.base16Scheme.name;

          editor = {
            auto-format = false;
            bufferline = "multiple";
            color-modes = true;
            cursorline = true;
            cursor-shape.insert = "bar";
            end-of-line-diagnostics = "warning";
            file-picker.hidden = false;
            idle-timeout = 0;
            inline-diagnostics.cursor-line = "hint";
            line-number = "relative";

            shell = [
              config.home.sessionVariables.SHELL
              "--commands"
            ];

            statusline = {
              right = [
                "version-control"
                "diagnostics"
                "selections"
                "position"
                "total-line-numbers"
              ];

              mode = {
                normal = "N";
                insert = "I";
                select = "S";
              };
            };

            whitespace = {
              character.tab = "→";
              render.tab = "all";
            };

            indent-guides = {
              character = "▏";
              render = true;
            };
          };

          keys = {
            normal = {
              C-down = [
                "page_cursor_half_down"
                "align_view_center"
              ];

              C-up = [
                "page_cursor_half_up"
                "align_view_center"
              ];

              x = "select_line_below";
              X = "select_line_above";
            };

            select = {
              x = "select_line_below";
              X = "select_line_above";
            };
          };
        };

        languages.language-server.rust-analyzer.config = {
          cargo.features = "all";
          check.command = "clippy";
          completion.callable.snippets = "add_parentheses";

          diagnostics.disabled = [
            "inactive-code"
            "unlinked-file"
          ];
        };
      };
    }
  );
}
