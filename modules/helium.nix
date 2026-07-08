{ moduleWithSystem, ... }: {
  flake.modules.homeManager.helium = moduleWithSystem (
    { inputs', ... }:
    { lib, ... }:
    let
      inherit (lib.meta) getExe;
    in
    {
      home = {
        sessionVariables.BROWSER = getExe inputs'.helium.packages.helium;
        packages = [ inputs'.helium.packages.helium ];
      };
    }
  );
}
