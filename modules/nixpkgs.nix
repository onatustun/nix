{ inputs, ... }:
let
  config = {
    allowBroken = true;
    allowUnfree = true;
  };
in
{
  disabledModules = [ inputs.flake-parts.flakeModules.nixpkgs ];

  perSystem = { system, ... }: {
    _module.args.pkgs = import inputs.nixpkgs { inherit system config; };
  };

  flake.modules.nixos.nixpkgs = { lib, ... }: {
    nixpkgs = { inherit config; };
    system.stateVersion = lib.trivial.release;
  };
}
