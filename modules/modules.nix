{ inputs, ... }: with inputs.flake-parts.flakeModules;
{
  imports = [ modules ];

  disabledModules = [
    apps
    nixosModules
    overlays
  ];
}
