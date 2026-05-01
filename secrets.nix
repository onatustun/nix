let
  keys = import ./keys.nix;
in
{
  "modules/hosts/server/attic/attic-env.age".publicKeys = keys.ssh.hosts { };
  "modules/hosts/server/radicle/radicle-private-key.age".publicKeys = keys.ssh.hosts { };
  "modules/nix/github-token.age".publicKeys = keys.ssh.hosts { };
  "modules/tailscale/authkey.age".publicKeys = keys.ssh.hosts { };
}
