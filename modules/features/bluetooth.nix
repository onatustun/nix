{
  flake.modules.nixos.bluetooth = {
    hardware.bluetooth = {
      enable = true;

      settings = {
        Policy.AutoEnable = true;

        General = {
          Experimental = true;
          FastConnectable = true;
        };
      };
    };

    services.blueman.enable = true;
  };
}
