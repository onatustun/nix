{ inputs, ... }:
{
  imports = [ inputs.flake-parts.flakeModules.modules ];

  disabledModules = [
    inputs.flake-parts.flakeModules.apps
    inputs.flake-parts.flakeModules.nixosModules
    inputs.flake-parts.flakeModules.overlays
  ];
}
