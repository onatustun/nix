{
  flake.modules.nixos.ssh =
    {
      lib,
      keys,
      username,
      ...
    }:
    let
      inherit (lib.modules) mkDefault;
    in
    {
      users.users = {
        root.openssh.authorizedKeys.keys = mkDefault keys.ssh.users.admins;
        ${username}.openssh.authorizedKeys.keys = mkDefault keys.ssh.users.admins;
      };

      programs.mosh.enable = true;

      services.openssh = {
        enable = true;

        settings = {
          KbdInteractiveAuthentication = false;
          PasswordAuthentication = false;
        };
      };
    };
}
