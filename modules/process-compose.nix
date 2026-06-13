{ inputs, ... }: { imports = [ (inputs.process-compose-flake + "/nix/flake-module.nix") ]; }
