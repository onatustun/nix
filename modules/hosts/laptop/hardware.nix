{ inputs, ... }: {
  flake.nixosConfigurations.laptop.module = { modulesPath, ... }: {
    imports = [
      (inputs.nixos-hardware.outPath + "/framework/13-inch/7040-amd")
      (modulesPath + "/installer/scan/not-detected.nix")
    ];

    nixpkgs.hostPlatform.system = "x86_64-linux";

    boot = {
      kernelModules = [ "kvm-amd" ];

      initrd.availableKernelModules = [
        "nvme"
        "xhci_pci"
        "thunderbolt"
        "usb_storage"
        "sd_mod"
      ];
    };

    services.upower.enable = true;
  };
}
