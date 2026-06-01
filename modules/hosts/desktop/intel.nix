{
  flake.nixosConfigurations.desktop.module =
    { config, ... }:
    {
      boot.kernelModules = [ "kvm-intel" ];
      hardware.cpu.intel.updateMicrocode = config.hardware.enableRedistributableFirmware;
    };
}
