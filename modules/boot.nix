{
  flake.modules.nixos.boot =
    { pkgs, ... }:
    {
      boot = {
        tmp.cleanOnBoot = true;

        loader = {
          efi.canTouchEfiVariables = true;
          systemd-boot.enable = true;
          timeout = 3;
        };
      };

      environment.systemPackages = [ pkgs.efibootmgr ];
    };
}
