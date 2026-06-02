{
  flake.nixosConfigurations.desktop.module =
    { lib, ... }:
    let
      inherit (lib.modules) mkForce;
    in
    {
      systemd.defaultUnit = mkForce "multi-user.target";
    };
}
