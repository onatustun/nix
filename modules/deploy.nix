{ inputs, config, ... }: {
  perSystem = { system, inputs', ... }: {
    checks = inputs.deploy-rs.lib.${system}.deployChecks config.flake.deploy;
    make-shells.default.packages = [ inputs'.deploy-rs.packages.default ];
  };
}
