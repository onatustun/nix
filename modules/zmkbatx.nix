{
  flake.modules.homeManager.zmkbatx =
    {
      lib,
      config,
      pkgs,
      ...
    }:
    let
      inherit (lib.meta) getExe' getExe;
    in
    {
      systemd.user.services.zmkbatx = {
        Unit = {
          After = [ config.wayland.systemd.target ];
          PartOf = [ config.wayland.systemd.target ];
        };

        Service = {
          ExecStartPre = "${getExe' pkgs.coreutils "sleep"} 5";
          ExecStart = getExe pkgs.zmkbatx;
          Restart = "on-failure";
          RestartSec = 3;
        };

        Install.WantedBy = [ config.wayland.systemd.target ];
      };
    };
}
