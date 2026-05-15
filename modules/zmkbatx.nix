{
  flake.modules.homeManager.zmkbatx =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      inherit (config.wayland.systemd) target;
      inherit (lib.meta) getExe;
    in
    {
      systemd.user.services.zmkbatx = {
        Unit = {
          After = [ target ];
          PartOf = [ target ];
        };

        Service = {
          ExecStart = getExe pkgs.zmkbatx;
          Restart = "on-failure";
          RestartSec = 5;
        };

        Install.WantedBy = [ target ];
      };
    };
}
