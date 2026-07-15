{ inputs, ... }: {
  perSystem =
    {
      pkgs,
      lib,
      inputs',
      ...
    }:
    let
      inherit (pkgs.writers) writeText;
      inherit (lib.strings) concatLines removePrefix;
      inherit (lib.attrsets) mapAttrsToList;
      inherit (lib.trivial) const;
      inherit (lib.generators) toPretty;
    in
    {
      make-shells.default = {
        env.RULES = writeText "secrets.nix" ''
          {
            ${
              concatLines
              <| mapAttrsToList (const (
                { file, publicKeys }:
                ''
                  "${
                    removePrefix (inputs.self.sourceInfo.outPath + "/") <| toString file
                  }".publicKeys = ${toPretty { } publicKeys};
                ''
              )) inputs.self.outputs.secrets
            }
          }
        '';

        packages = [ inputs'.agenix.packages.agenix ];
      };
    };

  flake =
    { lib, config, ... }:
    let
      inherit (lib.options) mkOption;
      inherit (lib.types)
        lazyAttrsOf
        submodule
        str
        path
        either
        listOf
        ;
      inherit (lib.trivial) flip const;
      inherit (lib.attrsets)
        attrValues
        isAttrs
        mapAttrs
        attrNames
        genAttrs
        ;
      inherit (lib.lists)
        concatMap
        isList
        filter
        unique
        ;
      inherit (lib.strings) isString;
    in
    {
      options.secrets = mkOption {
        type =
          lazyAttrsOf
          <| submodule {
            options = {
              file = mkOption { type = path; };
              publicKeys = mkOption { type = either str <| listOf str; };
            };
          };

        default = { };
      };

      config = {
        keys =
          let
            dropFunctor = flip removeAttrs [ "__functor" ];

            flattenTree =
              tree:
              tree
              |> dropFunctor
              |> attrValues
              |> concatMap (
                node:
                if isList node then
                  node
                else if isAttrs node then
                  if node ? __functor then node { } else flattenTree node
                else if isString node && node != "" then
                  [ node ]
                else
                  [ ]
              );

            mkTree =
              tree:
              (tree |> mapAttrs (const (node: if isString node || isList node then node else mkTree node)))
              // {
                __functor = self: const <| flattenTree self;
              };

            rawKeys = mkTree {
              ssh = {
                hosts = {
                  desktop = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOkTg+eQtVPavIgeaEig6kz6uRVxkRxm1VTc4Bg/Z0lt host/nixos/desktop";
                  laptop = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFVULgggFJuA5qbNN2KuSBFCkN6JLIVgO1YIqk0/Povi host/nixos/laptop";
                  server = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDw2WiINr5s9OGXkQRcyUcB4BKvUJI9B1y0DgkjBNM00 host/nixos/server";
                };

                users = {
                  desktop = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINZjRC59/OYgy+zxrcTPVxhLjlvascA7KAzybIOb0XvS user/nixos/desktop";
                  laptop = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIzxmJcUMSUM32Ng9yrDnA8twvn1rRoKYc+A/oLrdFcp user/nixos/laptop";
                };
              };

              u2f = {
                primary = "JLXDGTk3Ga2sRBz1cCrARjYbPySed5ZGDVX+T70NBePnAAZsxeAiK0Cl4cBXUjZ+3mx/bicbocJdYBf1WpHClw==,XuyXJU85C9ytixnVMBrx5jRuEujpkQJGxW/dS9ZlhjUXzgKw1q4xivdAaN9eFP9WKmDm0RyGo/t3EtxD4wvq0w==,es256,+presence";
                secondary = "lzcAIIfjWzUj3lXxYfCmKDMBJ3QnajAS1bjlqyNP3ece+oN75482SS5vXyPDpK1fBF0+qgzRz3BF8wuC1IUwTQ==,JzQBz79Mg9/uVf5r5J9IsrBDOgSI9hbzaEl2qWnfhSAagT+NVbpibGNRguVMtUjbfzo/jGb20xkJy1r87yelGg==,es256,+presence";
              };

              radicle.server = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJ43Y56T1aCI1maMsRbe+z8xLzxijMDwgyA4ZPzhEv3R radicle";
            };

            sshTypes = rawKeys.ssh |> dropFunctor;

            adminDevices = [
              "desktop"
              "laptop"
            ];

            typeKeys =
              sshTypes
              |> mapAttrs (
                const (
                  type:
                  type
                  // {
                    __functor = const <| const <| type { };
                    admins = adminDevices |> filter (device: type ? ${device}) |> map (device: type.${device});
                  }
                )
              );

            deviceKeys =
              sshTypes
              |> attrValues
              |> concatMap (type: type |> dropFunctor |> attrNames)
              |> unique
              |> flip genAttrs (
                device:
                sshTypes |> attrValues |> concatMap (type: if type ? ${device} then [ type.${device} ] else [ ])
              );
          in
          rawKeys
          // {
            ssh =
              rawKeys.ssh
              // typeKeys
              // deviceKeys
              // {
                __functor = const <| const <| rawKeys.ssh { };
                admins = adminDevices |> concatMap (device: deviceKeys.${device}) |> unique;
              };
          };

        modules.nixos.ragenix = {
          imports = [ (inputs.agenix.sourceInfo.outPath + "/modules/age.nix") ];
          _module.args = { inherit (config) keys; };
        };
      };
    };
}
