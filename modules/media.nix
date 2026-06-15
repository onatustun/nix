{
  flake.modules.homeManager.media = { pkgs, ... }: {
    home.packages = with pkgs; [
      ffmpeg-full
      haruna
      imv
      playerctl
    ];
  };
}
