{
  flake.nixosConfigurations.laptop.module.home-manager.extraSpecialArgs.monitors = {
    # Framework 13
    main.eDP-1 = {
      focus-at-startup = true;
      scale = 1.5;

      mode = {
        width = 2256;
        height = 1504;
        refresh = 60.000000;
      };

      position = {
        x = 0;
        y = -1080;
      };
    };

    # Xreal 1S
    DP-3 = {
      scale = 1.6;

      mode = {
        width = 1920;
        height = 1200;
        refresh = 90.000000;
      };

      position = {
        x = -152;
        y = -1830;
      };
    };
  };
}
