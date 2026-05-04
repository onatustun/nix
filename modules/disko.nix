{
  partitions.dev.module.perSystem =
    { inputs', ... }:
    {
      make-shells.default.packages = [ inputs'.disko.packages.default ];
    };
}
