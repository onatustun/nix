{ flake-parts, nixpkgs, ... }@inputs:
let
  inherit (flake-parts.lib) mkFlake;
  inherit (nixpkgs.lib.attrsets) filterAttrs;
  inherit (nixpkgs.lib.trivial) const;
  inherit (nixpkgs.lib.strings) hasPrefix;
in
mkFlake { inputs = inputs |> filterAttrs (n: const <| !hasPrefix "dep_" n); } (
  { lib, ... }:
  let
    inherit (lib.fileset) toList fileFilter;
  in
  {
    imports = ./modules |> fileFilter (file: file.hasExt "nix") |> toList;
  }
)
