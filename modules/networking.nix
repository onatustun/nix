{
  flake.modules.nixos.networking =
    { hostName, username, ... }:
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
      services.resolved.enable = true;
    };
}
