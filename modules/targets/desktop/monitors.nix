{
  flake.nixosConfigurations.desktop.module.home-manager.extraSpecialArgs.monitors = {
    # Koorui
    main.DP-2 = {
      focus-at-startup = { };
      scale = 1;
      mode = "1920x1080@240.299";

      position._props = {
        x = 1080;
        y = 350;
      };
    };

    # Alienware
    HDMI-A-1 = {
      scale = 1;
      mode = "1920x1080@239.761";
      transform = "90";

      position._props = {
        x = 0;
        y = 0;
      };
    };
  };
}
