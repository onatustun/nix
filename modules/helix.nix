{
  perSystem =
    { pkgs, ... }:
    {
      make-shells.default.packages = [ pkgs.nixd ];
    };

  flake.modules.homeManager.helix =
    { lib, config, ... }:
    let
      inherit (lib.meta) getExe;
    in
    {
      home.sessionVariables = {
        EDITOR = getExe config.programs.helix.package;
        VISUAL = config.home.sessionVariables.EDITOR;
      };

      programs.helix = {
        enable = true;

        settings = {
          editor = {
            true-color = true;
            default-yank-register = "+";
            middle-click-paste = false;
            line-number = "relative";
            cursorline = true;
            continue-comments = false;
            auto-format = false;
            idle-timeout = 0;
            completion-replace = true;
            bufferline = "multiple";
            color-modes = true;
            end-of-line-diagnostics = "warning";
            lsp.display-inlay-hints = true;
            cursor-shape.insert = "bar";
            file-picker.hidden = false;
            auto-save = false;
            inline-diagnostics.cursor-line = "warning";
            jump-label-alphabet = "jkl;hfdsagbceimnopqrtuvwxyz";

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
              characters = {
                tab = "→";
                space = "·";
              };

              render = {
                space = "all";
                tab = "all";
              };
            };

            gutters = {
              layout = [
                "diagnostics"
                "spacer"
                "line-numbers"
                "spacer"
                "diff"
              ];

              line-numbers.min-width = 1;
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
      };
    };
}
