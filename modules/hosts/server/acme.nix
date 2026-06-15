{
  flake.nixosConfigurations.server.module =
    { config, ... }:
    let
      inherit (config.networking) domain;
    in
    {
      security.acme = {
        acceptTerms = true;
        defaults.email = "mail@${domain}";
      };
    };
}
