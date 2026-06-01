{
  flake.nixosConfigurations.server.module =
    { rootDomain, ... }:
    {
      security.acme = {
        acceptTerms = true;
        defaults.email = "mail@${rootDomain}";
      };
    };
}
