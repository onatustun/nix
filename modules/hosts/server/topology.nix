{ inputs, ... }:
{
  flake.configurations.nixos.server.module = {
    imports = [ inputs.nix-topology.nixosModules.default ];
    topology.self.hardware.info = "Netcup VPS";
  };
}
