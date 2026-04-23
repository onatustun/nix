let
  keys = import ./keys.nix;
in
{
  "modules/nix/github-token.age".publicKeys = keys.ssh.hosts { };
  "modules/tailscale/authkey.age".publicKeys = keys.ssh.hosts { };
}
