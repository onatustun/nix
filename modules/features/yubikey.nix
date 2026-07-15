{
  flake.modules.nixos.yubikey = { pkgs, ... }: {
    environment.systemPackages = with pkgs; [
      age-plugin-yubikey
      yubioath-flutter
    ];

    programs = {
      yubikey-manager.enable = true;
      yubikey-touch-detector.enable = true;
    };

    services.udev.packages = with pkgs; [ libfido2 ];
  };
}
