{
  flake.configurations.nixos.laptop.module =
    { config, pkgs, ... }:
    {
      boot.kernelModules = [ "kvm-amd" ];
      hardware.cpu.amd.updateMicrocode = config.hardware.enableRedistributableFirmware;
      environment.systemPackages = [ pkgs.microcode-amd ];
    };
}
