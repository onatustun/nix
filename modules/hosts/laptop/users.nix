{
  flake.configurations.nixos.laptop.module =
    { username, ... }:
    {
      users.users.${username}.extraGroups = [
        "networkmanager"
        "storage"
        "video"
        "wheel"
      ];
    };
}
