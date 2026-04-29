{
  flake.configurations.nixos.server.module =
    { rootDomain, ... }:
    {
      security.acme = {
        acceptTerms = true;
        defaults.email = "mail@${rootDomain}";
      };
    };
}
