{ inputs, ... }:
{
  flake =
    { config, ... }:
    {
      modules = {
        nixos.dms = {
          imports = [ inputs.dms.nixosModules.greeter ];
          security.pam.services.dms-greeter.enableGnomeKeyring = true;

          programs.dank-material-shell.greeter = {
            enable = true;
            compositor.name = "niri";
          };

          home-manager.sharedModules = [ config.modules.homeManager.dms ];
        };

        homeManager.dms =
          { lib, ... }:
          let
            inherit (lib.lists) singleton;
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
                  "dms"
                  "ipc"
                  "spotlight"
                  "toggle"
                ];

                XF86AudioMute.action.spawn = [
                  "dms"
                  "ipc"
                  "audio"
                  "mute"
                ];

                XF86AudioMicMute.action.spawn = [
                  "dms"
                  "ipc"
                  "audio"
                  "micmute"
                ];

                XF86AudioPlay.action.spawn = [
                  "dms"
                  "ipc"
                  "mpris"
                  "playPause"
                ];

                XF86AudioStop.action.spawn = [
                  "dms"
                  "ipc"
                  "mpris"
                  "pause"
                ];

                XF86AudioPrev.action.spawn = [
                  "dms"
                  "ipc"
                  "mpris"
                  "previous"
                ];

                XF86AudioNext.action.spawn = [
                  "dms"
                  "ipc"
                  "mpris"
                  "next"
                ];

                XF86AudioRaiseVolume.action.spawn = [
                  "dms"
                  "ipc"
                  "audio"
                  "increment"
                  "5"
                ];

                XF86AudioLowerVolume.action.spawn = [
                  "dms"
                  "ipc"
                  "audio"
                  "decrement"
                  "5"
                ];
              };
            };
          };
      };
    };
}
