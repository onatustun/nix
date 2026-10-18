{ flake-parts, ... }@inputs:
let
  inherit (flake-parts.lib) evalFlakeModule;
in
evalFlakeModule { inherit inputs; } (
  { lib, ... }:
  let
    inherit (lib.fileset) fileFilter toList;
  in
  {
    imports = ./modules |> fileFilter ({ hasExt, ... }: hasExt "nix") |> toList;
  }
)
|> ({ config, graph, ... }: config.processedFlake // { inherit graph; })
