{ inputs, ... }: {
  flake =
    { config, ... }@flake:
    {
      secrets.github-token = {
        file = ./github-token.age;
        publicKeys = config.keys.ssh.hosts { };
      };

      modules.nixos.nix =
        {
          lib,
          pkgs,
          config,
          ...
        }:
        let
          inherit (lib.attrsets) mapAttrsToList mapAttrs;
          inherit (lib.trivial) const;
          inherit (lib.lists) singleton;
        in
        {
          age.secrets.github-token = { inherit (flake.config.secrets.github-token) file; };

          nixpkgs.config = {
            allowBroken = true;
            allowUnfree = true;
            permittedInsecurePackages = [ "radicle-node-1.10.3" ];
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
            package = pkgs.nixVersions.latest;
            channel.enable = false;
            nixPath = config.nix.registry |> mapAttrsToList (name: const "${name}=flake:${name}");

            registry =
              inputs
              |> mapAttrs (
                const (flake: {
                  inherit flake;
                })
              );

            extraOptions = "!include ${config.age.secrets.github-token.path}";
            optimise.automatic = true;

            settings = {
              auto-optimise-store = true;
              extra-substituters = [ "https://nix-community.cachix.org" ];
              extra-trusted-public-keys = singleton "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs=";
              flake-registry = "/etc/nix/registry.json";
              keep-outputs = true;
              show-trace = true;
              trusted-users = [ "@wheel" ];
              use-cgroups = true;
              warn-dirty = false;

              experimental-features = [
                "cgroups"
                "flakes"
                "nix-command"
                "pipe-operators"
              ];
            };
          };
        };
    };
}
