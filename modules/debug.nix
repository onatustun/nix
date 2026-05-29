{ lib, ... }:
let
  inherit (lib.attrsets) genAttrs;
  inherit (lib.lists) optional;
in
{
  partitionedAttrs =
    (_: "dev")
    |> genAttrs (
      [
        "allSystems"
        "debug"
      ]
      ++ optional (builtins ? currentSystem) "currentSystem"
    );

  partitions.dev.module =
    { getSystem, ... }:
    {
      debug = true;

      flake =
        { lib, ... }:
        let
          inherit (lib.attrsets) optionalAttrs;
          inherit (lib.modules) mkForce;
        in
        optionalAttrs (builtins ? currentSystem) {
          currentSystem = mkForce (getSystem builtins.currentSystem).debug;
        };
    };
}
