{ moduleWithSystem, ... }: {
  flake.nixosConfigurations.desktop.module = moduleWithSystem (
    { inputs', ... }: {
      boot.kernelPackages = inputs'.cachyos-kernel.legacyPackages.linuxPackages-cachyos-latest;
      programs.gamemode.enable = true;

      services.scx = {
        enable = true;
        scheduler = "scx_lavd";
      };

      home-manager.sharedModules = [ ({ pkgs, ... }: { home.packages = with pkgs; [ prismlauncher ]; }) ];
    }
  );
}
