{ inputs, ... }:
{
  flake.configurations.nixos.laptop.module =
    { pkgs, ... }:
    {
      imports = [ inputs.nixos-hardware.nixosModules.framework-13-7040-amd ];
      hardware.framework.enableKmod = true;
      environment.systemPackages = [ pkgs.framework-tool ];
    };
}
