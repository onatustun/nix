{
  flake.modules.nixos.nh =
    { homeDir, ... }:
    {
      programs.nh = {
        enable = true;
        flake = "${homeDir}/nix";

        clean = {
          enable = true;
          extraArgs = "--keep 5 --keep-since 5d";
        };
      };
    };
}
