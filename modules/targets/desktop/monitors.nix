{
  flake.nixosConfigurations.desktop.module.home-manager.extraSpecialArgs.monitors = {
    # Alienware
    main.HDMI-A-1 = {
      scale = 1;

      mode = {
        width = 1920;
        height = 1080;
        refresh = 239.761;
      };

      transform.rotation = 90;

      position = {
        x = 0;
        y = 0;
      };
    };

    # Koorui
    DP-2 = {
      focus-at-startup = true;
      scale = 1;

      mode = {
        width = 1920;
        height = 1080;
        refresh = 240.299;
      };

      position = {
        x = 1080;
        y = 350;
      };
    };
  };
}
