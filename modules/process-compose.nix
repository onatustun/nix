{ inputs, ... }: { imports = [ (inputs.process-compose-flake.outPath + "/nix/flake-module.nix") ]; }
