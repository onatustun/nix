{ inputs, ... }: {
  flake.nixosConfigurations.server.module = {
    imports = [ (inputs.nix-topology + "/nixos/module.nix") ];
    topology.self.hardware.info = "Netcup VPS";
  };
}
