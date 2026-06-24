{ inputs, ... }: {
  imports = [ (inputs.git-hooks.outPath + "/flake-module.nix") ];

  perSystem = { config, pkgs, ... }: {
    make-shells.default.inputsFrom = [ config.pre-commit.devShell ];

    pre-commit.settings = {
      package = pkgs.prek;

      hooks.flake-checker = {
        enable = true;

        args = [
          "--condition"
          "numDaysOld < 12"
        ];
      };
    };
  };
}
