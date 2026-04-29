let
  keys = import ./keys.nix;
in
{
  "modules/hosts/server/radicle/private-key.age".publicKeys = keys.ssh.hosts { };
  "modules/nix/github-token.age".publicKeys = keys.ssh.hosts { };
  "modules/tailscale/authkey.age".publicKeys = keys.ssh.hosts { };
}
