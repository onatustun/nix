{
  flake = { config, ... }: {
    modules = {
      nixos.nushell = { username, pkgs, ... }: {
        users.users.${username}.shell = pkgs.nushell;
        home-manager.sharedModules = [ config.modules.homeManager.nushell ];
      };

      homeManager.nushell =
        { lib, config, ... }:
        let
          inherit (lib.meta) getExe;
          inherit (lib.strings) readFile;
        in
        {
          home = {
            sessionVariables.SHELL = getExe config.programs.nushell.package;
            shell.enableShellIntegration = true;
          };

          programs.nushell = {
            enable = true;
            extraConfig = readFile ./extraConfig.nu;

            environmentVariables = {
              inherit (config.home.sessionVariables)
                BROWSER
                EDITOR
                SHELL
                VISUAL
                ;

              NIXPKGS_ALLOW_UNFREE = "1";
              PROMPT_COMMAND = "";
              PROMPT_COMMAND_RIGHT = "";
              PROMPT_INDICATOR_VI_INSERT = "";
              PROMPT_INDICATOR_VI_NORMAL = "";
              TRANSIENT_PROMPT_COMMAND = "";
              TRANSIENT_PROMPT_COMMAND_RIGHT = "";
              TRANSIENT_PROMPT_INDICATOR = "";
              TRANSIENT_PROMPT_INDICATOR_VI_NORMAL = "";
              TRANSIENT_PROMPT_INDICATOR_VI_INSERT = "";
              TRANSIENT_PROMPT_MULTILINE_INDICATOR = "";
            };
          };
        };
    };
  };
}
