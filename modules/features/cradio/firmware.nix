{
  perSystem =
    {
      inputs',
      lib,
      config,
      ...
    }:
    let
      inherit (inputs'.zmk-nix.legacyPackages) buildSplitKeyboard;
      inherit (lib.fileset) toSource intersection gitTracked;
      root = ./.;
    in
    {
      packages = {
        firmware = buildSplitKeyboard {
          name = "firmware";

          src = toSource {
            inherit root;
            fileset = intersection (gitTracked root) <| root + /config;
          };

          board = "nice_nano@2.0.0//zmk";
          shield = "cradio_%PART%";

          zephyrDepsHash = "sha256-777sDty25V5VbWgXjYKpy1NEW/rWJEihU7DRdqfk30I=";

          meta = {
            description = "ZMK firmware";
            inherit (inputs'.zmk-nix.packages.firmware.meta) license platforms;
          };
        };

        flash = inputs'.zmk-nix.packages.flash.override { inherit (config.packages) firmware; };
      };

      checks = { inherit (config.packages) firmware flash; };
    };
}
