{ inputs, ... }: {
  flake.nixosConfigurations.laptop.module.imports = [
    (inputs.nixos-hardware + "/framework/13-inch/7040-amd")
  ];
}
