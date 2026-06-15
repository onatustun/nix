{
  flake.nixosConfigurations.desktop.module._module.args.monitors = {
    # Alienware
    main.HDMI-A-1 = {
      focus-at-startup = true;
      scale = 1;

      mode = {
        width = 1920;
        height = 1080;
        refresh = 239.761;
      };

      position = {
        x = 0;
        y = 0;
      };
    };

    # Koorui
    DP-2 = {
      scale = 1;

      mode = {
        width = 1920;
        height = 1080;
        refresh = 240.299;
      };

      transform.rotation = 180;

      position = {
        x = 0;
        y = -1080;
      };
    };
  };
}
