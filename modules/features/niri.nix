{
  flake.modules.nixos.niri =
    { lib, pkgs, ... }:
    let
      inherit (lib.lists) singleton;
    in
    {
      programs.niri = {
        enable = true;
        useNautilus = false;
      };

      systemd.user.services.niri-flake-polkit = {
        description = "PolicyKit Authentication Agent provided by niri-flake";
        wantedBy = [ "niri.service" ];
        after = [ "graphical-session.target" ];
        partOf = [ "graphical-session.target" ];

        serviceConfig = {
          Type = "simple";
          ExecStart = pkgs.kdePackages.polkit-kde-agent-1 + "/libexec/polkit-kde-authentication-agent-1";
          Restart = "on-failure";
          RestartSec = 1;
          TimeoutStopSec = 10;
        };
      };

      home-manager.sharedModules = singleton (
        {
          lib,
          pkgs,
          config,
          monitors,
          ...
        }:
        let
          inherit (lib.attrsets) mapAttrsToList;
          inherit (lib.trivial) flip;
          inherit (lib.meta) getExe;
        in
        {
          home.packages = with pkgs; [ playerctl ];

          wayland.windowManager.niri = {
            enable = true;

            settings = {
              environment = {
                CLUTTER_BACKEND = "wayland";
                ELECTRON_OZONE_PLATFORM_HINT = "auto";
                GDK_BACKEND = "wayland,x11";
                MOZ_ENABLE_WAYLAND = "1";
                NIXOS_OZONE_WL = "1";
                SDL_VIDEODRIVER = "wayland";
                QT_QPA_PLATFORM = "wayland";
                QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
                XCURSOR_SIZE = toString config.stylix.cursor.size;
                XDG_CURRENT_DESKTOP = "niri";
                XDG_SESSION_TYPE = "wayland";
              };

              _children =
                mapAttrsToList (
                  name: value: {
                    output = value // {
                      _args = [ name ];
                    };
                  }
                )
                <| (monitors |> flip removeAttrs [ "main" ]) // (monitors.main or { });

              overview.backdrop-color = config.stylix.base16Scheme.base01;

              cursor = {
                hide-after-inactive-ms = 1000;
                xcursor-size = config.stylix.cursor.size;
                xcursor-theme = config.stylix.cursor.name;
              };

              layout = {
                background-color = config.stylix.base16Scheme.base00;
                focus-ring.off = { };

                border = {
                  width = 3;
                  active-color = config.stylix.base16Scheme.base0D;
                  inactive-color = config.stylix.base16Scheme.base03;
                };

                struts = {
                  left = 8;
                  right = 8;
                  top = 8;
                  bottom = 8;
                };
              };

              binds = {
                "Mod+Q".spawn = [ config.home.sessionVariables.TERMINAL ];
                "Mod+E".spawn = [ (getExe pkgs.thunar) ];
                "Mod+Z".spawn = [ config.home.sessionVariables.BROWSER ];
                "Mod+C".close-window = [ ];
                "Mod+O".toggle-overview = [ ];
                "Mod+Shift+E".quit = [ ];
                "Mod+F".maximize-column = [ ];
                "Mod+Shift+F".fullscreen-window = [ ];
                "Mod+V".toggle-window-floating = [ ];
                "Mod+Shift+V".switch-focus-between-floating-and-tiling = [ ];
                "Mod+M".center-visible-columns = [ ];
                "Mod+Comma".consume-or-expel-window-left = [ ];
                "Mod+Period".consume-or-expel-window-right = [ ];
                "Mod+H".focus-column-left = [ ];
                "Mod+J".focus-window-or-workspace-down = [ ];
                "Mod+K".focus-window-or-workspace-up = [ ];
                "Mod+L".focus-column-right = [ ];
                "Mod+Left".focus-column-left = [ ];
                "Mod+Down".focus-window-or-workspace-down = [ ];
                "Mod+Up".focus-window-or-workspace-up = [ ];
                "Mod+Right".focus-column-right = [ ];
                "Mod+BracketLeft".focus-column-first = [ ];
                "Mod+BracketRight".focus-column-last = [ ];
                "Mod+Ctrl+H".move-column-left = [ ];
                "Mod+Ctrl+J".move-window-down-or-to-workspace-down = [ ];
                "Mod+Ctrl+K".move-window-up-or-to-workspace-up = [ ];
                "Mod+Ctrl+L".move-column-right = [ ];
                "Mod+Ctrl+Left".move-column-left = [ ];
                "Mod+Ctrl+Down".move-column-to-workspace-down = [ ];
                "Mod+Ctrl+Up".move-column-to-workspace-up = [ ];
                "Mod+Ctrl+Right".move-column-right = [ ];
                "Super+Shift+H".focus-monitor-left = [ ];
                "Super+Shift+J".focus-monitor-down = [ ];
                "Super+Shift+K".focus-monitor-up = [ ];
                "Super+Shift+L".focus-monitor-right = [ ];
                "Super+Shift+Left".focus-monitor-left = [ ];
                "Super+Shift+Down".focus-monitor-down = [ ];
                "Super+Shift+Up".focus-monitor-up = [ ];
                "Super+Shift+Right".focus-monitor-right = [ ];
                "Mod+Ctrl+Shift+H".move-column-to-monitor-left = [ ];
                "Mod+Ctrl+Shift+J".move-column-to-monitor-down = [ ];
                "Mod+Ctrl+Shift+K".move-column-to-monitor-up = [ ];
                "Mod+Ctrl+Shift+L".move-column-to-monitor-right = [ ];
                "Mod+Ctrl+Shift+Left".move-column-to-monitor-left = [ ];
                "Mod+Ctrl+Shift+Down".move-column-to-monitor-down = [ ];
                "Mod+Ctrl+Shift+Up".move-column-to-monitor-up = [ ];
                "Mod+Ctrl+Shift+Right".move-column-to-monitor-right = [ ];
                "Super+Alt+H".set-column-width = "-25%";
                "Super+Alt+J".set-window-height = "+25%";
                "Super+Alt+K".set-window-height = "-25%";
                "Super+Alt+L".set-column-width = "+25%";
                "Super+Alt+Left".set-column-width = "-25%";
                "Super+Alt+Down".set-window-height = "+25%";
                "Super+Alt+Up".set-window-height = "-25%";
                "Super+Alt+Right".set-column-width = "+25%";
                "Mod+1".focus-workspace = 1;
                "Mod+2".focus-workspace = 2;
                "Mod+3".focus-workspace = 3;
                "Mod+4".focus-workspace = 4;
                "Mod+5".focus-workspace = 5;
                "Mod+6".focus-workspace = 6;
                "Mod+7".focus-workspace = 7;
                "Mod+8".focus-workspace = 8;
                "Mod+9".focus-workspace = 9;
                "Mod+0".focus-workspace = 10;
                "Mod+Shift+1".move-column-to-workspace = 1;
                "Mod+Shift+2".move-column-to-workspace = 2;
                "Mod+Shift+3".move-column-to-workspace = 3;
                "Mod+Shift+4".move-column-to-workspace = 4;
                "Mod+Shift+5".move-column-to-workspace = 5;
                "Mod+Shift+6".move-column-to-workspace = 6;
                "Mod+Shift+7".move-column-to-workspace = 7;
                "Mod+Shift+8".move-column-to-workspace = 8;
                "Mod+Shift+0".move-column-to-workspace = 10;
              };

              window-rule = {
                clip-to-geometry = true;
                draw-border-with-background = false;

                geometry-corner-radius = [
                  16.0
                  16.0
                  16.0
                  16.0
                ];
              };

              prefer-no-csd = { };

              hotkey-overlay = {
                skip-at-startup = { };
                hide-not-bound = { };
              };

              input = {
                focus-follows-mouse._props.max-scroll-amount = "5%";
                keyboard.xkb.layout = "us";
                mod-key = "Super";
                warp-mouse-to-focus = { };
              };
            };
          };
        }
      );
    };
}
