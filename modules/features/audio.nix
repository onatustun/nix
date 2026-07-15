{
  flake.modules.nixos.audio = {
    security.rtkit.enable = true;

    services.pipewire = {
      alsa.support32Bit = true;
      jack.enable = true;
    };
  };
}
