{
  inputs = {
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
  };

  outputs = _: { };
}
