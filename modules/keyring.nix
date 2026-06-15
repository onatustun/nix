{
  flake.modules.nixos.keyring = { pkgs, ... }: {
    security.pam.services.login.enableGnomeKeyring = true;
    environment.systemPackages = [ pkgs.gnome-keyring ];
    programs.seahorse.enable = true;
  };
}
