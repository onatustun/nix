{ inputs, ... }: {
  flake.modules.homeManager.dms =
    { lib, config, ... }:
    let
      inherit (lib.meta) getExe;
      inherit (lib.lists) singleton;
      dms-shell = getExe config.programs.dank-material-shell.package;
    in
    {
      imports = [ inputs.dms.homeModules.dank-material-shell ];

      programs.dank-material-shell = {
        enable = true;
        systemd.enable = true;

        settings = {
          dockAutoHide = true;
          dockGroupByApp = true;
          dockIsolateDisplays = true;
          dockOpenOnOverview = true;
          launcherLogoMode = "os";
          launcherStyle = "spotlight";
          nightModeEnabled = true;
          notificationCompactMode = true;
          notificationFocusedMonitor = true;
          screenPreferences.wallpaper = [ ];
          showDock = true;
          showOccupiedWorkspacesOnly = true;
          useAutoLocation = true;

          barConfigs = singleton {
            id = "default";
            name = "Main Bar";
            enabled = true;
            position = 2;
            scrollEnabled = false;
            spacing = 0;
            squareCorners = true;

            leftWidgets = [
              {
                id = "launcherButton";
                enabled = true;
              }
              {
                id = "workspaceSwitcher";
                enabled = true;
              }
            ];

            centerWidgets = [ "clock" ];

            rightWidgets = [
              "systemTray"
              "clipboard"
              "cpuUsage"
              "memUsage"
              "notificationButton"
              "battery"
              "controlCenterButton"
            ];
          };
        };
      };

      wayland.windowManager.niri.settings.binds = {
        "Mod+D".spawn = [
          dms-shell
          "ipc"
          "spotlight"
          "toggle"
        ];

        XF86AudioMute.spawn = [
          dms-shell
          "ipc"
          "audio"
          "mute"
        ];

        XF86AudioMicMute.spawn = [
          dms-shell
          "ipc"
          "audio"
          "micmute"
        ];

        XF86AudioPlay.spawn = [
          dms-shell
          "ipc"
          "mpris"
          "playPause"
        ];

        XF86AudioStop.spawn = [
          dms-shell
          "ipc"
          "mpris"
          "pause"
        ];

        XF86AudioPrev.spawn = [
          dms-shell
          "ipc"
          "mpris"
          "previous"
        ];

        XF86AudioNext.spawn = [
          dms-shell
          "ipc"
          "mpris"
          "next"
        ];

        XF86AudioRaiseVolume.spawn = [
          dms-shell
          "ipc"
          "audio"
          "increment"
          "5"
        ];

        XF86AudioLowerVolume.spawn = [
          dms-shell
          "ipc"
          "audio"
          "decrement"
          "5"
        ];
      };
    };
}
