{
  flake.nixosConfigurations.desktop.module =
    { username, ... }:
    {
      users.users.${username}.extraGroups = [
        "storage"
        "wheel"
      ];
    };
}
