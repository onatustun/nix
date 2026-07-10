{
  flake.nixosConfigurations.desktop.module = {
    fileSystems = {
      "/" = {
        device = "/dev/disk/by-uuid/ab2dc6ee-7ca5-4306-80da-43255fabdd75";
        fsType = "ext4";
      };

      "/boot" = {
        device = "/dev/disk/by-uuid/86F4-D550";
        fsType = "vfat";

        options = [
          "fmask=0077"
          "dmask=0077"
        ];
      };
    };

    zramSwap.enable = true;
    swapDevices = [ { device = "/dev/disk/by-uuid/f21c6765-340e-4bbd-8a13-d902376a5430"; } ];
  };
}
