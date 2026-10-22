{ inputs, ... }: {
  flake.nixosConfigurations.desktop.module = { pkgs, ... }: {
    boot.kernelPackages =
      inputs.chaotic.unrestrictedPackages.${pkgs.stdenv.hostPlatform.system}.linuxPackages_cachyos;
    programs.gamemode.enable = true;

    services.scx = {
      enable = true;
      scheduler = "scx_lavd";
    };

    home-manager.sharedModules = [ ({ pkgs, ... }: { home.packages = with pkgs; [ prismlauncher ]; }) ];
  };
}
