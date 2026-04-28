{
  flake.modules.homeManager.helix =
    {
      lib,
      pkgs,
      config,
      ...
    }:
    let
      inherit (lib.meta) getExe;
    in
    {
      home = {
        packages = [
          pkgs.nixd
          pkgs.steel
        ];

        sessionVariables = {
          EDITOR = getExe config.programs.helix.package;
          VISUAL = config.home.sessionVariables.EDITOR;
        };
      };

      xdg.configFile = {
        "helix/init.scm".source = ./init.scm;
        "helix/themes/gruber-darker.toml".source = ./gruber-darker.toml;
      };

      programs.helix = {
        enable = true;
        package = pkgs.steelix;

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
            insert-final-newline = false;
            end-of-line-diagnostics = "warning";
            lsp.display-inlay-hints = true;
            cursor-shape.insert = "bar";
            file-picker.hidden = false;
            auto-save = false;
            inline-diagnostics.cursor-line = "warning";
            indent-guides.render = false;
            jump-label-alphabet = "jkl;hfdsagbceimnopqrtuvwxyz";

            shell = [
              config.home.sessionVariables.SHELL
              "--commands"
            ];

            statusline = {
              left = [
                "mode"
                "spinner"
                "file-name"
                "read-only-indicator"
                "file-modification-indicator"
              ];

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

              G = {
                j = "@vgj<esc>";
                k = "@vgk<esc>";
              };

              g = {
                j = "goto_last_line";
                k = "goto_file_start";
              };
            };

            select = {
              x = "select_line_below";
              X = "select_line_above";

              g = {
                j = "goto_last_line";
                k = "goto_file_start";
              };
            };
          };
        };

        languages = {
          language = [
            {
              name = "haskell";
              formatter = {
                command = "fourmolu";

                args = [
                  "--stdin-input-file"
                  "%{buffer_name}"
                ];
              };
            }
            {
              name = "scheme";
              language-servers = [ "steel-language-server" ];
            }
          ];

          language-server = {
            rust-analyzer.config = {
              cargo.features = "all";
              check.command = "clippy";
              completion.callable.snippets = "add_parentheses";
            };

            steel-language-server.command = "steel-language-server";
          };
        };
      };
    };
}
