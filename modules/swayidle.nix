{ moduleWithSystem, ... }:
{
  flake.modules.homeManager.swayidle = moduleWithSystem (
    { inputs', ... }:
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      inherit (config.wayland.systemd) target;
      inherit (lib.lists) singleton;
      inherit (lib.meta) getExe;
    in
    {
      services.swayidle = {
        enable = true;

        timeouts = singleton {
          timeout = 300;
          command = "${getExe inputs'.noctalia.packages.default} ipc call lockScreen lock";
        };
      };

      systemd.user.services.sway-audio-idle-inhibit = {
        Unit = {
          After = [ target ];
          PartOf = [ target ];
          BindsTo = [ target ];
          Requisite = [ target ];
        };

        Service = {
          ExecStart = getExe pkgs.sway-audio-idle-inhibit;
          Slice = "app.slice";
          Restart = "on-failure";
        };

        Install.WantedBy = [ target ];
      };
    }
  );
}
