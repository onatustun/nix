{
  flake.nixosConfigurations.server.module = { username, ... }: {
    users.users.${username}.extraGroups = [ "wheel" ];
  };
}
