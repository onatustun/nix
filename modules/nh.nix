{
  flake.modules.nixos.nh =
    {
      lib,
      config,
      pkgs,
      ...
    }:
    let
      inherit (lib.meta) getExe;
    in
    {
      systemd = {
        services.nh-clean = {
          description = "nh clean";
          startAt = "weekly";
          path = [ config.nix.package ];

          serviceConfig = {
            Type = "oneshot";
            ExecStart = "${getExe pkgs.nh} clean all --keep 5 --keep-since 5d";
          };
        };

        timers.nh-clean.timerConfig.Persistent = true;
      };
    };
}
