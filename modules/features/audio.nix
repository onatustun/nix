{
  flake.modules.nixos.audio = {
    security.rtkit.enable = true;
    services.pipewire.jack.enable = true;
  };
}
