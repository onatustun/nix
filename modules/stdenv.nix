{
  partitions.dev.module.perSystem =
    { pkgs, ... }:
    {
      make-shells.default.stdenv = pkgs.stdenvNoCC;
    };
}
