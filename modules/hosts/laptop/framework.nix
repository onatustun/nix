{ inputs, ... }:
{
  flake.configurations.nixos.laptop.module.imports = [
    inputs.nixos-hardware.nixosModules.framework-13-7040-amd
  ];
}
