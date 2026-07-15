{ inputs, ... }:
let
  inherit (inputs.deploy-rs.lib.x86_64-linux) activate;
in
{
  flake = { config, ... }: {
    deploy.nodes.server = {
      hostname = "server";

      profiles.system = {
        sshUser = "root";
        path = activate.nixos config.nixosConfigurations.server;
      };
    };
  };
}
