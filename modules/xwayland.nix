{ moduleWithSystem, ... }:
{
  flake.modules.homeManager.xwayland = moduleWithSystem (
    { inputs', ... }:
    { lib, config, ... }:
    let
      inherit (lib.meta) getExe;
    in
    {
      systemd.user.services.xwayland-satellite = {
        Unit = {
          BindsTo = [ config.wayland.systemd.target ];
          PartOf = [ config.wayland.systemd.target ];
          After = [ config.wayland.systemd.target ];
          Requisite = [ config.wayland.systemd.target ];
        };

        Service = {
          Type = "notify";
          NotifyAccess = "all";
          ExecStart = "${getExe inputs'.xwayland-satellite.packages.default}";
          StandardOutput = "journal";
        };
      };
    }
  );
}
