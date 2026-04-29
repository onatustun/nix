{ inputs, ... }:
{
  flake =
    { config, ... }:
    {
      configurations = {
        nixos.server.module.imports = [
          config.configurations.disko.server
          inputs.disko.nixosModules.default
        ];

        disko.server.disko.devices.disk.main = {
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
    };
}
