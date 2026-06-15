{
  flake.nixosConfigurations.laptop.module = { username, ... }: {
    users.users.${username}.extraGroups = [
      "storage"
      "video"
      "wheel"
    ];
  };
}
