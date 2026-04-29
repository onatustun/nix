{
  flake.modules.nixos.networking =
    {
      hostName,
      username,
      pkgs,
      ...
    }:
    {
      networking = {
        inherit hostName;
        firewall.checkReversePath = "loose";

        networkmanager = {
          enable = true;
          wifi.powersave = false;
        };
      };

      users.users.${username}.extraGroups = [ "networkmanager" ];
      environment.systemPackages = [ pkgs.networkmanagerapplet ];
      services.resolved.enable = true;
    };
}
