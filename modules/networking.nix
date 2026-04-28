{
  flake.modules.nixos.networking =
    { hostName, pkgs, ... }:
    {
      networking = {
        inherit hostName;
        firewall.checkReversePath = "loose";

        networkmanager = {
          enable = true;
          wifi.powersave = false;
        };
      };

      environment.systemPackages = [ pkgs.networkmanagerapplet ];
      services.resolved.enable = true;
    };
}
