{ inputs, ... }:
let
  config = {
    allowBroken = true;
    allowUnfree = true;
  };
in
{
  disabledModules = [ inputs.flake-parts.flakeModules.nixpkgs ];

  perSystem =
    { system, ... }:
    {
      _module.args.pkgs = import inputs.nixpkgs { inherit system config; };
    };

  flake.modules = {
    nixos.nixpkgs =
      { lib, ... }:
      let
        inherit (lib.modules) mkDefault;
      in
      {
        nixpkgs = { inherit config; };
        system.stateVersion = mkDefault lib.trivial.release;
      };

    homeManager.nixpkgs =
      { lib, ... }:
      let
        inherit (lib.modules) mkDefault;
      in
      {
        nixpkgs = { inherit config; };
        home.stateVersion = mkDefault lib.trivial.release;
      };
  };
}
