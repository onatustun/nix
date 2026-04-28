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
      inherit (lib.lists) singleton;
    in
    {
      users.users = {
        root.openssh.authorizedKeys.keys = mkDefault keys.ssh.users.admins;
        ${username}.openssh.authorizedKeys.keys = mkDefault keys.ssh.users.admins;
      };

      programs.ssh.startAgent = false;

      services.openssh = {
        enable = true;
        settings.KbdInteractiveAuthentication = false;

        hostKeys = singleton {
          path = "/etc/ssh/ssh_host_ed25519_key";
          type = "ed25519";
        };
      };
    };
}
