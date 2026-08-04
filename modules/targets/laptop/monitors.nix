{
  flake.nixosConfigurations.laptop.module.home-manager.extraSpecialArgs.monitors = {
    # Framework 13
    main.eDP-1 = {
      focus-at-startup = { };
      scale = 1.5;
      mode = "2256x1504@60.000000";

      position._props = {
        x = 0;
        y = -1080;
      };
    };

    # Xreal 1S
    DP-3 = {
      scale = 1.2;
      mode = "1920x1200@90.000000";

      position._props = {
        x = -48;
        y = -2080;
      };
    };
  };
}
