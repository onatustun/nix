{ flake-parts, ... }@inputs:
let
  inherit (flake-parts.lib) mkFlake;
in
mkFlake { inherit inputs; } (
  { lib, ... }:
  let
    inherit (lib.fileset) toList fileFilter;
  in
  {
    imports = ./modules |> fileFilter (file: file.hasExt "nix") |> toList;
  }
)
