{
  description = "Nix config";

  nixConfig = {
    commit-lockfile-summary = "chore: update `flake.lock`";

    extra-substituters = [
      "https://nix-community.cachix.org"
      "https://cache.onatustun.com/zmk"
      "https://niri.cachix.org"
      "https://noctalia.cachix.org"
    ];

    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "zmk:zQgRE8h8eHNmG2btJWg4p6Hl2tuYwhkmfqsaxC5ju6I="
      "niri.cachix.org-1:Wv0OmO7PsuocRKzfDoJ3mulSl7Z6oezYhGhR+3W2964="
      "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4="
    ];

    extra-experimental-features = [
      "flakes"
      "nix-command"
      "pipe-operators"
    ];
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

    nix-topology = {
      type = "github";
      owner = "oddlama";
      repo = "nix-topology";
      flake = false;
    };

    home-manager = {
      type = "github";
      owner = "nix-community";
      repo = "home-manager";
      flake = false;
    };

    zmk-nix = {
      type = "github";
      owner = "lilyinstarlight";
      repo = "zmk-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    oil-hx = {
      type = "github";
      owner = "Ra77a3l3-jar";
      repo = "oil.hx";
      flake = false;
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

    disko = {
      type = "github";
      owner = "nix-community";
      repo = "disko";
      inputs.nixpkgs.follows = "nixpkgs";
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

    nixos-hardware = {
      type = "github";
      owner = "nixos";
      repo = "nixos-hardware";
    };

    bambuddy = {
      type = "git";
      url = "https://seed.onatustun.com/zVH7U6HxxwtdWd2WwHBBK7uUEn4Q.git";
      flake = false;
    };

    nix-index-database = {
      type = "github";
      owner = "nix-community";
      repo = "nix-index-database";
      flake = false;
    };

    stylix = {
      type = "github";
      owner = "nix-community";
      repo = "stylix";

      inputs = {
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

    noctalia = {
      type = "github";
      owner = "noctalia-dev";
      repo = "noctalia-shell";

      inputs = {
        nixpkgs.follows = "nixpkgs";
        noctalia-qs.follows = "dep_noctalia-qs";
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

    dep_noctalia-qs = {
      type = "github";
      owner = "noctalia-dev";
      repo = "noctalia-qs";

      inputs = {
        nixpkgs.follows = "nixpkgs";
        systems.follows = "systems";
        treefmt-nix.follows = "";
      };
    };
  };

  outputs =
    { flake-parts, ... }@inputs:
    let
      inherit (flake-parts.lib) mkFlake;
    in
    mkFlake { inherit inputs; } (
      { lib, ... }:
      let
        inherit (lib.fileset) fileFilter toList;
      in
      {
        imports = ./modules |> fileFilter (file: file.hasExt "nix") |> toList;
      }
    );
}
