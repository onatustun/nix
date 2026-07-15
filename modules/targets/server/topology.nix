{ inputs, ... }: {
  flake.nixosConfigurations.server.module = {
    imports = [ (inputs.nix-topology.sourceInfo.outPath + "/nixos/module.nix") ];
    topology.self.hardware.info = "Netcup VPS";
  };
}
