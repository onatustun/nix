{
  inputs,
  config,
  moduleWithSystem,
  ...
}:
{
  perSystem =
    { pkgs, lib, ... }:
    let
      inherit (pkgs.stdenvNoCC) mkDerivation;
    in
    {
      packages.oil-hx = mkDerivation {
        pname = "oil.hx";
        version = "0.1.0";
        src = inputs.oil-hx;

        installPhase = ''
          mkdir -p $out/share/steel/cogs/oil
          cp -r . $out/share/steel/cogs/oil
        '';

        meta = {
          license = lib.licenses.mit;
          platforms = config.systems;
        };
      };
    };

  flake.modules.homeManager.helix = moduleWithSystem (
    { config, ... }:
    {
      xdg.dataFile."steel/cogs/oil" = {
        source = "${config.packages.oil-hx}/share/steel/cogs/oil";
        recursive = true;
      };
    }
  );
}
