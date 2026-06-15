{
  flake.modules.nixos.boot.boot = {
    tmp.cleanOnBoot = true;

    loader = {
      efi.canTouchEfiVariables = true;

      systemd-boot = {
        enable = true;
        configurationLimit = 5;
      };
    };
  };
}
