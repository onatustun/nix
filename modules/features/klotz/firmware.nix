{ inputs, ... }: {
  perSystem =
    {
      inputs',
      pkgs,
      lib,
      config,
      ...
    }:
    let
      inherit (inputs'.zmk-nix.legacyPackages) buildSplitKeyboard;
      inherit (pkgs) runCommand;
      inherit (lib.fileset) toSource intersection gitTracked;
      root = ./.;
    in
    {
      packages = {
        klotz-firmware = buildSplitKeyboard {
          name = "klotz firmware";

          src = runCommand "klotz-config" { } ''
            mkdir -p $out

            cp -r ${
              toSource {
                inherit root;
                fileset = intersection (gitTracked root) (root + /config);
              }
            }/* $out/

            mkdir -p $out/boards
            cp -r ${inputs.klotz}/config/boards/shields $out/boards/
          '';

          board = "nice_nano@2.0.0//zmk";
          shield = "klotz_%PART%";

          zephyrDepsHash = "sha256-gXzT6Q60qsThjPtJOiWkAa+sUsf2/Lpilvw5Plvxgxo=";

          meta = {
            description = "ZMK firmware for klotz";
            inherit (inputs'.zmk-nix.packages.firmware.meta) license platforms;
          };
        };

        klotz-flash = inputs'.zmk-nix.packages.flash.override {
          firmware = config.packages.klotz-firmware;
        };
      };

      checks = { inherit (config.packages) klotz-firmware klotz-flash; };
    };
}
