{
  flake.modules.homeManager.wl-clipboard = { pkgs, ... }: {
    home.packages = with pkgs; [ wl-clipboard ];
    programs.helix.settings.editor.clipboard-provider = "wayland";

    services = {
      cliphist.enable = true;
      wl-clip-persist.enable = true;
    };
  };
}
