{
  flake.nixosConfigurations.laptop.module =
    { modulesPath, pkgs, ... }:
    {
      imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

      boot.initrd.availableKernelModules = [
        "nvme"
        "xhci_pci"
        "thunderbolt"
        "usb_storage"
        "sd_mod"
      ];

      environment.systemPackages = [ pkgs.kmod ];
    };
}
