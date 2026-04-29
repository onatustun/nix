{
  flake.configurations.nixos.desktop.module =
    { username, ... }:
    {
      users.users.${username}.extraGroups = [
        "networkmanager"
        "storage"
        "wheel"
      ];
    };
}
