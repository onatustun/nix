{
  flake.modules.nixos.keyring =
    { pkgs, ... }:
    {
      security.pam.services.gdm-password.enableGnomeKeyring = true;
      environment.systemPackages = [ pkgs.gnome-keyring ];
      programs.seahorse.enable = true;
    };
}
