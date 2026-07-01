{ inputs, ... }: {
  imports = [ (inputs.flake-parts.outPath + "/extras/modules.nix") ];

  disabledModules = [
    (inputs.flake-parts.outPath + "/modules/apps.nix")
    (inputs.flake-parts.outPath + "/modules/nixosModules.nix")
    (inputs.flake-parts.outPath + "/modules/overlays.nix")
  ];
}
