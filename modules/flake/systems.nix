{ inputs, ... }: { systems = import <| inputs.self.sourceInfo.outPath + "/systems.nix"; }
