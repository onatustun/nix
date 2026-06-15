{
  flake.modules.nixos.yubikey = { pkgs, ... }: {
    environment.systemPackages = with pkgs; [
      age-plugin-yubikey
      cryptsetup
      fido2-manage
      yubikey-manager
      yubikey-personalization
      yubioath-flutter
    ];

    programs.yubikey-touch-detector = {
      enable = true;
      libnotify = true;
    };

    services = {
      pcscd.enable = true;

      udev.packages = with pkgs; [
        libfido2
        libu2f-host
        yubikey-personalization
      ];
    };
  };
}
