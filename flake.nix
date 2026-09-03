{
  outputs = inputs: import ./outputs.nix inputs;

  nixConfig = {
    extra-substituters = [
      "https://nix-community.cachix.org"
      "https://cache.onatustun.com/zmk"
    ];

    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "zmk:zQgRE8h8eHNmG2btJWg4p6Hl2tuYwhkmfqsaxC5ju6I="
    ];

    extra-experimental-features = [
      "flakes"
      "nix-command"
      "pipe-operators"
    ];

    flake-registry = "";
  };

  inputs = {
    nixpkgs = {
      type = "tarball";
      url = "https://channels.nixos.org/nixos-unstable/nixexprs.tar.zst";
    };

    flake-parts = {
      type = "github";
      owner = "hercules-ci";
      repo = "flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };

    treefmt-nix = {
      type = "github";
      owner = "numtide";
      repo = "treefmt-nix";
      flake = false;
    };

    git-hooks = {
      type = "github";
      owner = "cachix";
      repo = "git-hooks.nix";
      flake = false;
    };

    make-shell = {
      type = "github";
      owner = "nicknovitski";
      repo = "make-shell";
      flake = false;
    };

    process-compose-flake = {
      type = "github";
      owner = "platonic-systems";
      repo = "process-compose-flake";
      flake = false;
    };

    services-flake = {
      type = "github";
      owner = "juspay";
      repo = "services-flake";
      flake = false;
    };

    nix-topology = {
      type = "github";
      owner = "oddlama";
      repo = "nix-topology";
      flake = false;
    };

    zmk-nix = {
      type = "github";
      owner = "lilyinstarlight";
      repo = "zmk-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    klotz = {
      type = "github";
      owner = "geigeigeist";
      repo = "zmk-config-klotz";
      flake = false;
    };

    deploy-rs = {
      type = "github";
      owner = "serokell";
      repo = "deploy-rs";

      inputs = {
        flake-compat.follows = "";
        nixpkgs.follows = "nixpkgs";
        utils.inputs.systems.follows = "dep_systems";
      };
    };

    agenix = {
      type = "github";
      owner = "ryantm";
      repo = "agenix";

      inputs = {
        darwin.follows = "";
        home-manager.follows = "";
        nixpkgs.follows = "nixpkgs";
        systems.follows = "dep_systems";
      };
    };

    disko = {
      type = "github";
      owner = "nix-community";
      repo = "disko";
      flake = false;
    };

    nixos-hardware = {
      type = "github";
      owner = "nixos";
      repo = "nixos-hardware";
      flake = false;
    };

    home-manager = {
      type = "github";
      owner = "nix-community";
      repo = "home-manager";
      flake = false;
    };

    stylix = {
      type = "github";
      owner = "nix-community";
      repo = "stylix";

      inputs = {
        base16-fish.follows = "";
        base16-helix.follows = "";
        base16-vim.follows = "";
        firefox-gnome-theme.follows = "";
        flake-parts.follows = "flake-parts";
        nixpkgs.follows = "nixpkgs";
        nur.follows = "";
        systems.follows = "dep_systems";
        tinted-kitty.follows = "";
        tinted-schemes.follows = "";
        tinted-zed.follows = "";
      };
    };

    dms = {
      type = "github";
      owner = "avengemedia";
      repo = "dankmaterialshell";

      inputs = {
        flake-compat.follows = "";
        nixpkgs.follows = "nixpkgs";
      };
    };

    helium = {
      type = "github";
      owner = "amaanq";
      repo = "helium-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  inputs.dep_systems = {
    type = "path";
    path = "./systems.nix";
    flake = false;
  };
}
