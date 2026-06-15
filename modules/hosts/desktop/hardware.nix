{
  flake.nixosConfigurations.desktop.module = { modulesPath, config, ... }: {
    imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];
    nixpkgs.hostPlatform.system = "x86_64-linux";

    boot = {
      kernelModules = [ "kvm-intel" ];

      initrd.availableKernelModules = [
        "xhci_pci"
        "ahci"
        "usb_storage"
        "sd_mod"
      ];
    };

    hardware = {
      cpu.intel.updateMicrocode = config.hardware.enableRedistributableFirmware;

      nvidia = {
        modesetting.enable = true;
        open = false;
        package = config.boot.kernelPackages.nvidiaPackages.beta;
      };
    };

    services.xserver.videoDrivers = [ "nvidia" ];
  };
}
