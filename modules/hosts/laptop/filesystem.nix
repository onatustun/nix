{
  flake.nixosConfigurations.laptop.module = {
    fileSystems = {
      "/" = {
        device = "/dev/disk/by-uuid/506db6ea-c537-4c30-a710-1aafaef3cf8a";
        fsType = "ext4";
      };

      "/boot" = {
        device = "/dev/disk/by-uuid/CB13-7E41";
        fsType = "vfat";

        options = [
          "fmask=0077"
          "dmask=0077"
        ];
      };
    };

    zramSwap.enable = true;
    swapDevices = [ { device = "/dev/disk/by-uuid/f2ce709b-e968-4dbd-b4ce-f8b6f8b81afd"; } ];
  };
}
