{
  flake.nixosConfigurations.server.module = { config, ... }: {
    security.acme = {
      acceptTerms = true;
      defaults.email = "mail@${config.networking.domain}";
    };
  };
}
