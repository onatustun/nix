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

        settings = {
          cursor_shape = {
            emacs = "line";
            vi_insert = "line";
            vi_normal = "block";
          };

          show_banner = false;
          use_ansi_coloring = true;
          error_style = "fancy";
          footer_mode = 25;
          float_precision = 2;
          render_right_prompt_on_last_line = false;
          datetime_format = { };
          rm.always_trash = false;

          history = {
            file_format = "sqlite";
            isolation = false;
            max_size = 1000000;
            sync_on_enter = true;
          };

          completions = {
            algorithm = "substring";
            case_sensitive = false;
            partial = true;
            quick = true;
            sort = "smart";
            use_ls_colors = true;
          };

          ls = {
            use_ls_colors = true;
            clickable_links = true;
          };

          use_kitty_protocol = true;

          shell_integration = {
            osc2 = false;
            osc7 = true;
            osc8 = true;
            osc9_9 = false;
            osc133 = true;
            osc633 = true;
            reset_application_mode = true;
          };

          bracketed_paste = true;
          edit_mode = "vi";
          buffer_editor = "hx";
        };
      };
    };
}
