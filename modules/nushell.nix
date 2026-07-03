{
  flake.modules.homeManager.nushell =
    { lib, config, ... }:
    let
      inherit (lib.meta) getExe;
    in
    {
      home = {
        shell.enableShellIntegration = true;

        sessionVariables = {
          NIXPKGS_ALLOW_UNFREE = "1";
          PROMPT_COMMAND = "";
          PROMPT_COMMAND_RIGHT = "";
          PROMPT_INDICATOR_VI_INSERT = "";
          PROMPT_INDICATOR_VI_NORMAL = "";
          SHELL = getExe config.programs.nushell.package;
          TRANSIENT_PROMPT_COMMAND = "";
          TRANSIENT_PROMPT_COMMAND_RIGHT = "";
          TRANSIENT_PROMPT_INDICATOR = "";
          TRANSIENT_PROMPT_INDICATOR_VI_INSERT = "";
          TRANSIENT_PROMPT_INDICATOR_VI_NORMAL = "";
          TRANSIENT_PROMPT_MULTILINE_INDICATOR = "";
        };
      };

      programs.nushell = {
        enable = true;
        environmentVariables = config.home.sessionVariables;

        extraConfig = /* nu */ ''
          $env.config.cursor_shape = {
            emacs: line
            vi_insert: line
            vi_normal: block
          }

          $env.config.show_banner = false
          $env.config.use_ansi_coloring = true
          $env.config.error_style = "fancy"
          $env.config.footer_mode = 25
          $env.config.float_precision = 2
          $env.config.render_right_prompt_on_last_line = false
          $env.config.datetime_format = {}
          $env.config.rm.always_trash = false

          $env.config.history = {
            file_format: sqlite
            isolation: false
            max_size: 1_000_000
            sync_on_enter: true
          }

          $env.config.completions = {
            algorithm: substring
            case_sensitive: false
            partial: true
            quick: true
            sort: smart
            use_ls_colors: true
          }

          $env.config.ls = {
            use_ls_colors: true
            clickable_links: true
          }

          $env.config.use_kitty_protocol = true
          $env.config.shell_integration = {
            osc2: false
            osc7: true
            osc8: true
            osc9_9: false
            osc133: true
            osc633: true
            reset_application_mode: true
          }

          $env.config.bracketed_paste = true
          $env.config.edit_mode = "vi"
          $env.config.buffer_editor = "hx"
        '';
      };
    };
}
