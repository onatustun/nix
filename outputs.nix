{ flake-parts, nixpkgs, ... }@allInputs:
let
  inherit (flake-parts.lib) mkFlake;
  inherit (nixpkgs.lib.attrsets) filterAttrs;
  inherit (nixpkgs.lib.trivial) const;
  inherit (nixpkgs.lib.strings) hasPrefix;
in
mkFlake { inputs = allInputs |> filterAttrs (n: const <| !hasPrefix "dep_" n); } (
  { lib, ... }:
  let
    inherit (lib.fileset) toList fileFilter;
  in
  {
    imports = ./modules |> fileFilter ({ hasExt, ... }: hasExt "nix") |> toList;
  }
)
