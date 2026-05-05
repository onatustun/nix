{
  flake.modules.nixos.boot =
    { pkgs, ... }:
    {
      boot = {
        tmp.cleanOnBoot = true;

        loader = {
          efi.canTouchEfiVariables = true;
          timeout = 3;

          systemd-boot = {
            enable = true;
            configurationLimit = 5;
          };
        };
      };

      environment.systemPackages = [ pkgs.efibootmgr ];
    };
}
