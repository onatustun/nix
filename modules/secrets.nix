{ inputs, ... }: {
  perSystem = { inputs', ... }: {
    make-shells.default = {
      shellHook = ''
        export RULES="$(git rev-parse --show-toplevel)/secrets.nix"
      '';

      packages = [ inputs'.ragenix.packages.default ];
    };
  };

  flake = { config, ... }: {
    keys = import inputs.keys.outPath;

    modules.nixos.ragenix = {
      imports = [ inputs.ragenix.nixosModules.default ];
      _module.args = { inherit (config) keys; };
    };
  };
}
