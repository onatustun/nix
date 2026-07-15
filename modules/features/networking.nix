{
  flake.modules.nixos.networking = { username, ... }: {
    networking = {
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
