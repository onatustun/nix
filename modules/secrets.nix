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
    keys = import <| inputs.self.sourceInfo.outPath + "/keys.nix";

    modules.nixos.ragenix = {
      imports = [ (inputs.agenix.sourceInfo.outPath + "/modules/age.nix") ];
      _module.args = { inherit (config) keys; };
    };
  };
}
