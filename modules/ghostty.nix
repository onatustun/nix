{
  flake.modules.homeManager.ghostty =
    { lib, config, ... }:
    let
      inherit (lib.meta) getExe;
    in
    {
      home.sessionVariables.TERMINAL = getExe config.programs.ghostty.package;

      programs.ghostty = {
        enable = true;
        installBatSyntax = config.programs.bat.enable;
        installVimSyntax = true;

        settings = {
          command = "${config.home.sessionVariables.SHELL} --login";
          confirm-close-surface = false;
          mouse-hide-while-typing = true;
          shell-integration-features = "no-cursor";
          bold-is-bright = true;
          gtk-titlebar = false;
          window-decoration = "auto";
          window-padding-x = 0;
          window-padding-y = 0;

          font-feature = [
            "-calt"
            "-liga"
            "-dlig"
          ];
        };
      };
    };
}
