{
  flake.modules.nixos.acme.security.acme = {
    acceptTerms = true;
    defaults.email = "mail@onatustun.com";
  };
}
