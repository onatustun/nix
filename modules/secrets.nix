{ inputs, ... }: {
  perSystem = { inputs', ... }: {
    make-shells.default = {
      shellHook = ''
        export RULES="$(git rev-parse --show-toplevel)/secrets.nix"
      '';

      packages = [ inputs'.agenix.packages.agenix ];
    };
  };

  flake = { config, ... }: {
    keys = import inputs.keys.outPath;

    modules.nixos.ragenix = {
      imports = [ (inputs.agenix.outPath + "/modules/age.nix") ];
      _module.args = { inherit (config) keys; };
    };
  };
}
