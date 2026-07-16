{ inputs, ... }: {
  flake =
    { config, ... }@flake:
    {
      secrets.github-token = {
        file = ./github-token.age;
        publicKeys = config.keys.ssh.hosts { };
      };

      modules.nixos.nix =
        { lib, config, ... }:
        let
          inherit (lib.attrsets) mapAttrsToList mapAttrs;
          inherit (lib.trivial) const;
          inherit (lib.lists) singleton;
          registryInputs = { inherit (inputs) flake-parts nixpkgs; };
        in
        {
          age.secrets.github-token = { inherit (flake.config.secrets.github-token) file; };

          nixpkgs.config = {
            allowBroken = true;
            allowUnfree = true;
          };

          system.disableInstallerTools = true;

          programs.nh = {
            enable = true;

            clean = {
              enable = true;
              extraArgs = "--keep 5 --keep-since 3d";
            };
          };

          nix = {
            channel.enable = false;
            nixPath = registryInputs |> mapAttrsToList (name: flake: "${name}=${flake}");

            registry =
              registryInputs
              |> mapAttrs (
                const (flake: {
                  inherit flake;
                })
              );

            extraOptions = "!include ${config.age.secrets.github-token.path}";

            settings = {
              auto-optimise-store = true;
              extra-substituters = [ "https://nix-community.cachix.org" ];
              extra-trusted-public-keys = singleton "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs=";
              flake-registry = "/etc/nix/registry.json";
              keep-outputs = true;
              show-trace = true;
              use-cgroups = true;
              warn-dirty = false;

              experimental-features = [
                "cgroups"
                "flakes"
                "nix-command"
                "pipe-operators"
              ];

              trusted-users = [
                "root"
                "@wheel"
              ];
            };
          };
        };
    };
}
