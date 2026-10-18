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
        cradio-firmware = buildSplitKeyboard {
          name = "cradio firmware";

          src = toSource {
            inherit root;
            fileset = intersection (gitTracked root) <| root + /config;
          };

          board = "nice_nano@2.0.0//zmk";
          shield = "cradio_%PART%";

          zephyrDepsHash = "sha256-zDnYk7iavZLcuPRrl8QUMROnvikwBGOrDa5prc2cFtk=";

          meta = {
            description = "ZMK firmware for cradio";
            inherit (inputs'.zmk-nix.packages.firmware.meta) license platforms;
          };
        };

        cradio-flash = inputs'.zmk-nix.packages.flash.override {
          firmware = config.packages.cradio-firmware;
        };
      };

      checks = { inherit (config.packages) cradio-firmware cradio-flash; };
    };
}
