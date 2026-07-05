{ flake-parts, ... }@inputs:
let
  inherit (flake-parts.lib) evalFlakeModule;
in
with evalFlakeModule { inherit inputs; } (
  { lib, ... }:
  let
    inherit (lib.fileset) fileFilter toList;
  in
  {
    imports = ./modules |> fileFilter ({ hasExt, ... }: hasExt "nix") |> toList;
  }
);
config.processedFlake // { inherit graph; }
