{ flake-parts, ... }@inputs:
let
  inherit (flake-parts.lib) mkFlake;
in
mkFlake { inherit inputs; } (
  { inputs, ... }:
  let
    inherit (inputs) import-tree;
  in
  import import-tree ./modules
)
