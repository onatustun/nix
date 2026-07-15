{ inputs, ... }: {
  imports = [ (inputs.flake-parts.sourceInfo.outPath + "/extras/modules.nix") ];

  disabledModules = [
    (inputs.flake-parts.sourceInfo.outPath + "/modules/apps.nix")
    (inputs.flake-parts.sourceInfo.outPath + "/modules/nixosModules.nix")
    (inputs.flake-parts.sourceInfo.outPath + "/modules/overlays.nix")
  ];
}
