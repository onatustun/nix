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
          PROMPT_MULTILINE_INDICATOR = "";
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
          bracketed_paste = true;
          completions.algorithm = "substring";
          edit_mode = "helix";
          error_style = "fancy";
          show_banner = false;
          use_ansi_coloring = true;
          use_kitty_protocol = true;

          cursor_shape = {
            helix_insert = "line";
            helix_normal = "block";
            helix_select = "block";
          };

          history = {
            file_format = "sqlite";
            max_size = 1000000;
          };
        };
      };
    };
}
