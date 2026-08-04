{ moduleWithSystem, inputs, ... }: {
  flake.modules.nixos.niri = moduleWithSystem (
    { inputs' }:
    { lib, ... }:
    let
      inherit (lib.lists) singleton;
    in
    {
      imports = [ inputs.niri.nixosModules.niri ];
      niri-flake.cache.enable = false;
      security.pam.services.ly.enableGnomeKeyring = true;
      services.displayManager.ly.enable = true;

      programs.niri = {
        enable = true;
        package = inputs'.niri.packages.niri-unstable;
      };

      home-manager.sharedModules =
        singleton
        <| moduleWithSystem (
          { inputs' }:
          {
            lib,
            config,
            monitors,
            pkgs,
            ...
          }:
          let
            inherit (lib.trivial) flip;
            inherit (lib.meta) getExe;
            inherit (lib.lists) singleton;
          in
          {
            home.packages = with pkgs; [ playerctl ];

            programs.niri.settings = {
              environment = {
                CLUTTER_BACKEND = "wayland";
                ELECTRON_OZONE_PLATFORM_HINT = "auto";
                GDK_BACKEND = "wayland,x11";
                MOZ_ENABLE_WAYLAND = "1";
                NIXOS_OZONE_WL = "1";
                SDL_VIDEODRIVER = "wayland";
                QT_QPA_PLATFORM = "wayland";
                QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
                XCURSOR_SIZE = toString config.home.pointerCursor.size;
                XDG_CURRENT_DESKTOP = "niri";
                XDG_SESSION_TYPE = "wayland";
              };

              outputs = (monitors |> flip removeAttrs [ "main" ]) // monitors.main;
              overview.backdrop-color = config.stylix.base16Scheme.base01;

              layout = {
                always-center-single-column = true;
                border.width = 3;
                background-color = config.stylix.base16Scheme.base00;
                center-focused-column = "on-overflow";
                default-column-width.proportion = 0.5;

                struts = {
                  left = 8;
                  right = 8;
                  top = 8;
                  bottom = 8;
                };
              };

              binds = {
                "Mod+Q".action.spawn = config.home.sessionVariables.TERMINAL;
                "Mod+E".action.spawn = getExe pkgs.thunar;
                "Mod+Z".action.spawn = config.home.sessionVariables.BROWSER;
                "Mod+C".action.close-window = [ ];
                "Mod+O".action.toggle-overview = [ ];
                "Mod+Shift+E".action.quit = [ ];
                "Mod+F".action.maximize-column = [ ];
                "Mod+Shift+F".action.fullscreen-window = [ ];
                "Mod+V".action.toggle-window-floating = [ ];
                "Mod+Shift+V".action.switch-focus-between-floating-and-tiling = [ ];
                "Mod+M".action.center-visible-columns = [ ];
                "Mod+Comma".action.consume-or-expel-window-left = [ ];
                "Mod+Period".action.consume-or-expel-window-right = [ ];
                "Mod+H".action.focus-column-left = [ ];
                "Mod+J".action.focus-window-or-workspace-down = [ ];
                "Mod+K".action.focus-window-or-workspace-up = [ ];
                "Mod+L".action.focus-column-right = [ ];
                "Mod+Left".action.focus-column-left = [ ];
                "Mod+Down".action.focus-window-or-workspace-down = [ ];
                "Mod+Up".action.focus-window-or-workspace-up = [ ];
                "Mod+Right".action.focus-column-right = [ ];
                "Mod+BracketLeft".action.focus-column-first = [ ];
                "Mod+BracketRight".action.focus-column-last = [ ];
                "Mod+Ctrl+H".action.move-column-left = [ ];
                "Mod+Ctrl+J".action.move-window-down-or-to-workspace-down = [ ];
                "Mod+Ctrl+K".action.move-window-up-or-to-workspace-up = [ ];
                "Mod+Ctrl+L".action.move-column-right = [ ];
                "Mod+Ctrl+Left".action.move-column-left = [ ];
                "Mod+Ctrl+Down".action.move-column-to-workspace-down = [ ];
                "Mod+Ctrl+Up".action.move-column-to-workspace-up = [ ];
                "Mod+Ctrl+Right".action.move-column-right = [ ];
                "Super+Shift+H".action.focus-monitor-left = [ ];
                "Super+Shift+J".action.focus-monitor-down = [ ];
                "Super+Shift+K".action.focus-monitor-up = [ ];
                "Super+Shift+L".action.focus-monitor-right = [ ];
                "Super+Shift+Left".action.focus-monitor-left = [ ];
                "Super+Shift+Down".action.focus-monitor-down = [ ];
                "Super+Shift+Up".action.focus-monitor-up = [ ];
                "Super+Shift+Right".action.focus-monitor-right = [ ];
                "Mod+Ctrl+Shift+H".action.move-column-to-monitor-left = [ ];
                "Mod+Ctrl+Shift+J".action.move-column-to-monitor-down = [ ];
                "Mod+Ctrl+Shift+K".action.move-column-to-monitor-up = [ ];
                "Mod+Ctrl+Shift+L".action.move-column-to-monitor-right = [ ];
                "Mod+Ctrl+Shift+Left".action.move-column-to-monitor-left = [ ];
                "Mod+Ctrl+Shift+Down".action.move-column-to-monitor-down = [ ];
                "Mod+Ctrl+Shift+Up".action.move-column-to-monitor-up = [ ];
                "Mod+Ctrl+Shift+Right".action.move-column-to-monitor-right = [ ];
                "Super+Alt+H".action.set-column-width = "-25%";
                "Super+Alt+J".action.set-window-height = "+25%";
                "Super+Alt+K".action.set-window-height = "-25%";
                "Super+Alt+L".action.set-column-width = "+25%";
                "Super+Alt+Left".action.set-column-width = "-25%";
                "Super+Alt+Down".action.set-window-height = "+25%";
                "Super+Alt+Up".action.set-window-height = "-25%";
                "Super+Alt+Right".action.set-column-width = "+25%";
                "Mod+1".action.focus-workspace = 1;
                "Mod+2".action.focus-workspace = 2;
                "Mod+3".action.focus-workspace = 3;
                "Mod+4".action.focus-workspace = 4;
                "Mod+5".action.focus-workspace = 5;
                "Mod+6".action.focus-workspace = 6;
                "Mod+7".action.focus-workspace = 7;
                "Mod+8".action.focus-workspace = 8;
                "Mod+9".action.focus-workspace = 9;
                "Mod+0".action.focus-workspace = 10;
                "Mod+Shift+1".action.move-column-to-workspace = 1;
                "Mod+Shift+2".action.move-column-to-workspace = 2;
                "Mod+Shift+3".action.move-column-to-workspace = 3;
                "Mod+Shift+4".action.move-column-to-workspace = 4;
                "Mod+Shift+5".action.move-column-to-workspace = 5;
                "Mod+Shift+6".action.move-column-to-workspace = 6;
                "Mod+Shift+7".action.move-column-to-workspace = 7;
                "Mod+Shift+8".action.move-column-to-workspace = 8;
                "Mod+Shift+0".action.move-column-to-workspace = 10;
              };

              window-rules = singleton {
                clip-to-geometry = true;
                draw-border-with-background = false;

                geometry-corner-radius = {
                  bottom-left = 16.0;
                  bottom-right = 16.0;
                  top-left = 16.0;
                  top-right = 16.0;
                };
              };

              prefer-no-csd = true;

              hotkey-overlay = {
                skip-at-startup = true;
                hide-not-bound = true;
              };

              xwayland-satellite = {
                enable = true;
                path = getExe inputs'.niri.packages.xwayland-satellite-unstable;
              };

              input = {
                keyboard.xkb.layout = "us";
                mod-key = "Super";
                warp-mouse-to-focus.enable = true;

                focus-follows-mouse = {
                  enable = true;
                  max-scroll-amount = "5%";
                };
              };
            };
          }
        );
    }
  );
}
