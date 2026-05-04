{ inputs, ... }:
{
  flake.configurations.nixos.server.module = {
    imports = [ inputs.disko.nixosModules.default ];

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
  };
}
