{
  flake.modules.homeManager.wayvnc =
    {
      config,
      lib,
      pkgs,
      monitors,
      hostName,
      ...
    }:
    let
      inherit (config.wayland.systemd) target;
      inherit (lib.meta) getExe;
      inherit (lib.attrsets) attrNames;
      inherit (lib.lists) head;
    in
    {
      systemd.user.services.wayvnc = {
        Unit = {
          After = [ target ];
          PartOf = [ target ];
          BindsTo = [ target ];
          Requisite = [ target ];
        };

        Service = {
          ExecStart = "${getExe pkgs.wayvnc} -Linfo -o ${
            monitors.main |> attrNames |> head
          } ${hostName}.tail32e3ea.ts.net 5901";
          Restart = "on-failure";
          RestartSec = "1m";
        };

        Install.WantedBy = [ target ];
      };
    };
}
