{ flake-parts, nixpkgs, ... }@allInputs:
let
  inherit (flake-parts.lib) evalFlakeModule;
  inherit (nixpkgs.lib.attrsets) filterAttrs;
  inherit (nixpkgs.lib.trivial) const;
  inherit (nixpkgs.lib.strings) hasPrefix;
in
evalFlakeModule { inputs = allInputs |> filterAttrs (n: const <| !hasPrefix "dep_" n); } (
  { lib, ... }:
  let
    inherit (lib.fileset) fileFilter toList;
  in
  {
    imports = ./modules |> fileFilter ({ hasExt, ... }: hasExt "nix") |> toList;
  }
)
|> ({ config, graph, ... }: config.processedFlake // { inherit graph; })
