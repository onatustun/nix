{ inputs, ... }: {
  perSystem =
    { pkgs, inputs', ... }:
    let
      inherit (pkgs.writers) writeText;
    in
    {
      make-shells.default = {
        env.RULES = writeText "secrets.nix" ''
          let
            keys = import ${toString <| inputs.self.sourceInfo.outPath + "/keys.nix"};
          in
          {
            "modules/targets/server/attic/attic-env.age".publicKeys = keys.ssh.hosts { };
            "modules/targets/server/radicle/radicle-private-key.age".publicKeys = keys.ssh.hosts { };
            "modules/features/nix/github-token.age".publicKeys = keys.ssh.hosts { };
            "modules/features/tailscale/tailscale-authkey.age".publicKeys = keys.ssh.hosts { };
          }
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
