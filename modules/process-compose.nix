{ inputs, ... }: {
  imports = [ (inputs.process-compose-flake.sourceInfo.outPath + "/nix/flake-module.nix") ];
}
