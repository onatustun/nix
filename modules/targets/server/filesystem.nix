{ inputs, ... }: {
  flake.nixosConfigurations.server.module =
    { lib, ... }:
    let
      inherit (lib.lists) singleton;
    in
    {
      imports = [ (inputs.disko.sourceInfo.outPath + "/module.nix") ];

      disko.devices.disk.main = {
        type = "disk";
        device = "/dev/vda";

        content = {
          type = "gpt";

          partitions = {
            boot = {
              size = "1M";
              type = "EF02";
            };

            root = {
              size = "100%";

              content = {
                type = "filesystem";
                format = "ext4";
                mountpoint = "/";
              };
            };
          };
        };
      };

      zramSwap.enable = true;

      swapDevices = singleton {
        device = "/var/lib/swapfile";
        size = 4 * 1024;
      };
    };
}
