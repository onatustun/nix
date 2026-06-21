{ inputs, moduleWithSystem, ... }: {
  flake.modules.nixos.dms =
    { lib, ... }:
    let
      inherit (lib.lists) singleton;
    in
    {
      imports = [ inputs.dms.nixosModules.greeter ];
      security.pam.services.dms-greeter.enableGnomeKeyring = true;

      programs.dank-material-shell.greeter = {
        enable = true;
        compositor.name = "niri";
      };

      home-manager.sharedModules =
        singleton
        <| moduleWithSystem (
          { inputs', ... }:
          { lib, ... }:
          let
            inherit (lib.lists) singleton;
            inherit (lib.meta) getExe;
            inherit (inputs'.dms.packages) dms-shell;
          in
          {
            imports = [ inputs.dms.homeModules.dank-material-shell ];

            programs = {
              dank-material-shell = {
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

              niri.settings.binds = {
                "Mod+D".action.spawn = [
                  (getExe dms-shell)
                  "ipc"
                  "spotlight"
                  "toggle"
                ];

                XF86AudioMute.action.spawn = [
                  (getExe dms-shell)
                  "ipc"
                  "audio"
                  "mute"
                ];

                XF86AudioMicMute.action.spawn = [
                  (getExe dms-shell)
                  "ipc"
                  "audio"
                  "micmute"
                ];

                XF86AudioPlay.action.spawn = [
                  (getExe dms-shell)
                  "ipc"
                  "mpris"
                  "playPause"
                ];

                XF86AudioStop.action.spawn = [
                  (getExe dms-shell)
                  "ipc"
                  "mpris"
                  "pause"
                ];

                XF86AudioPrev.action.spawn = [
                  (getExe dms-shell)
                  "ipc"
                  "mpris"
                  "previous"
                ];

                XF86AudioNext.action.spawn = [
                  (getExe dms-shell)
                  "ipc"
                  "mpris"
                  "next"
                ];

                XF86AudioRaiseVolume.action.spawn = [
                  (getExe dms-shell)
                  "ipc"
                  "audio"
                  "increment"
                  "5"
                ];

                XF86AudioLowerVolume.action.spawn = [
                  (getExe dms-shell)
                  "ipc"
                  "audio"
                  "decrement"
                  "5"
                ];
              };
            };
          }
        );
    };
}
