{ inputs, ... }:
{
  flake.nixosConfigurations.laptop.module.imports = [
    inputs.nixos-hardware.nixosModules.framework-13-7040-amd
  ];
}
