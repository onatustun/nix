{
  flake.configurations.nixos.server.module =
    { username, ... }:
    {
      users.users.${username}.extraGroups = [ "wheel" ];
    };
}
