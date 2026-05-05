flake-parts: {
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
            fileset = intersection (gitTracked root) (root + /config);
          };

          board = "nice_nano@2.0.0//zmk";
          shield = "cradio_%PART%";

          zephyrDepsHash = "sha256-14G3J2LTnsu8L47afajd9SICaMR49FOcwQtgKIS5/iY=";

          meta = {
            description = "ZMK firmware";
            license = lib.licenses.mit;
            platforms = flake-parts.config.systems;
          };
        };

        inherit (inputs'.zmk-nix.packages) update;
        flash = inputs'.zmk-nix.packages.flash.override { inherit (config.packages) firmware; };
      };
    };

  partitions.dev.module.perSystem =
    {
      config,
      inputs',
      pkgs,
      ...
    }:
    {
      checks = { inherit (config.packages) firmware flash update; };

      make-shells.default = {
        inputsFrom = [ inputs'.zmk-nix.devShells.default ];
        packages = [ pkgs.keymap-drawer ];
      };
    };
}
