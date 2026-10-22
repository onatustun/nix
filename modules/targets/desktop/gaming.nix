{ moduleWithSystem, inputs, ... }: {
  flake.nixosConfigurations.desktop.module = moduleWithSystem (
    { system }: {
      boot.kernelPackages = inputs.chaotic.unrestrictedPackages.${system}.linuxPackages_cachyos;
      programs.gamemode.enable = true;

      services.scx = {
        enable = true;
        scheduler = "scx_lavd";
      };

      home-manager.sharedModules = [ ({ pkgs, ... }: { home.packages = with pkgs; [ prismlauncher ]; }) ];
    }
  );
}
