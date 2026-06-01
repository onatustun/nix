{
  flake.nixosConfigurations.desktop.module =
    { config, ... }:
    {
      hardware.nvidia = {
        modesetting.enable = true;
        open = false;
        package = config.boot.kernelPackages.nvidiaPackages.beta;
      };

      services.xserver.videoDrivers = [ "nvidia" ];
    };
}
