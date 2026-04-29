{
  flake.modules.homeManager.wayvnc =
    {
      lib,
      config,
      pkgs,
      monitors,
      hostName,
      ...
    }:
    let
      inherit (lib.meta) getExe;
      inherit (lib.lists) head;
      inherit (lib.attrsets) attrNames;
    in
    {
      systemd.user.services.wayvnc = {
        Unit = {
          After = [ config.wayland.systemd.target ];
          PartOf = [ config.wayland.systemd.target ];
        };

        Service = {
          ExecStart = "${getExe pkgs.wayvnc} -Linfo -o ${head (attrNames monitors.main)} ${hostName}.tail32e3ea.ts.net 5901";
          Restart = "on-failure";
          RestartSec = "1m";
        };

        Install.WantedBy = [ config.wayland.systemd.target ];
      };
    };
}
