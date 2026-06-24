{ inputs, ... }: {
  flake.nixosConfigurations.server.module = {
    imports = [ (inputs.nix-topology.outPath + "/nixos/module.nix") ];
    topology.self.hardware.info = "Netcup VPS";
  };
}
