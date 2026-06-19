{
  outputs = inputs: import ./outputs.nix inputs;

  nixConfig = {
    extra-substituters = [
      "https://nix-community.cachix.org"
      "https://cache.onatustun.com/zmk"
      "https://crane.cachix.org"
      "https://niri.cachix.org"
    ];

    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "zmk:zQgRE8h8eHNmG2btJWg4p6Hl2tuYwhkmfqsaxC5ju6I="
      "crane.cachix.org-1:8Scfpmn9w+hGdXH/Q9tTLiYAE/2dnJYRJP7kl80GuRk="
      "niri.cachix.org-1:Wv0OmO7PsuocRKzfDoJ3mulSl7Z6oezYhGhR+3W2964="
    ];

    extra-experimental-features = [
      "cgroups"
      "flakes"
      "nix-command"
      "pipe-operators"
    ];

    flake-registry = "";
    use-cgroups = true;
  };

  inputs = {
    nixpkgs = {
      type = "tarball";
      url = "https://channels.nixos.org/nixos-unstable/nixexprs.tar.xz";
    };

    flake-parts = {
      type = "github";
      owner = "hercules-ci";
      repo = "flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };

    systems = {
      type = "path";
      path = "./systems.nix";
      flake = false;
    };

    flake-root = {
      type = "github";
      owner = "srid";
      repo = "flake-root";
      flake = false;
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

    deploy-rs = {
      type = "github";
      owner = "serokell";
      repo = "deploy-rs";

      inputs = {
        flake-compat.follows = "";
        nixpkgs.follows = "nixpkgs";
        utils.follows = "dep_flake-utils";
      };
    };

    ragenix = {
      type = "github";
      owner = "yaxitech";
      repo = "ragenix";

      inputs = {
        agenix.follows = "dep_agenix";
        crane.follows = "dep_crane";
        flake-utils.follows = "dep_flake-utils";
        nixpkgs.follows = "nixpkgs";
        rust-overlay.follows = "dep_rust-overlay";
      };
    };

    keys = {
      type = "path";
      path = "./keys.nix";
      flake = false;
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
        systems.follows = "systems";
        tinted-kitty.follows = "";
        tinted-schemes.follows = "";
        tinted-tmux.follows = "";
        tinted-zed.follows = "";
      };
    };

    xwayland-satellite = {
      type = "github";
      owner = "supreeeme";
      repo = "xwayland-satellite";

      inputs = {
        nixpkgs.follows = "nixpkgs";
        rust-overlay.follows = "";
      };
    };

    niri = {
      type = "github";
      owner = "sodiboo";
      repo = "niri-flake";

      inputs = {
        niri-stable.follows = "";
        niri-unstable.follows = "dep_niri-unstable";
        nixpkgs.follows = "nixpkgs";
        nixpkgs-stable.follows = "";
        xwayland-satellite-stable.follows = "";
        xwayland-satellite-unstable.follows = "xwayland-satellite";
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

    dep_flake-utils = {
      type = "github";
      owner = "numtide";
      repo = "flake-utils";
      inputs.systems.follows = "systems";
    };

    dep_agenix = {
      type = "github";
      owner = "ryantm";
      repo = "agenix";

      inputs = {
        darwin.follows = "";
        home-manager.follows = "";
        nixpkgs.follows = "";
        systems.follows = "";
      };
    };

    dep_crane = {
      type = "github";
      owner = "ipetkov";
      repo = "crane";
    };

    dep_rust-overlay = {
      type = "github";
      owner = "oxalica";
      repo = "rust-overlay";
      inputs.nixpkgs.follows = "";
    };

    dep_niri-unstable = {
      type = "github";
      owner = "niri-wm";
      repo = "niri";

      inputs = {
        nixpkgs.follows = "nixpkgs";
        rust-overlay.follows = "";
      };
    };
  };
}
