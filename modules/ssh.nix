{
  flake.modules.nixos.ssh =
    { lib, ... }:
    let
      inherit (lib.lists) singleton;
    in
    {
      services.openssh = {
        enable = true;
        settings.KbdInteractiveAuthentication = false;

        hostKeys = singleton {
          path = "/etc/ssh/ssh_host_ed25519_key";
          type = "ed25519";
        };
      };

      programs.ssh.startAgent = false;
    };
}
