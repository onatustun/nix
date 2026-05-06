{
  flake.modules.nixos.users =
    {
      lib,
      username,
      homeDir,
      ...
    }:
    let
      inherit (lib.modules) mkDefault;
    in
    {
      _module.args.homeDir = "/home/${username}";

      users.users.${username} = {
        home = homeDir;
        createHome = true;
        isNormalUser = mkDefault true;
      };
    };
}
