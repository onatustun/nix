{ inputs, ... }:
{
  flake.nixosConfigurations.server.module =
    {
      rootDomain,
      config,
      lib,
      ...
    }:
    let
      domain = "bambuddy.${rootDomain}";
      inherit (config.services.bambuddy) port;
      inherit (lib.lists) singleton;
    in
    {
      imports = [ (inputs.bambuddy + "/nixos-module.nix") ];

      services = {
        nginx.virtualHosts.${domain} = {
          enableACME = true;
          forceSSL = true;
          locations."/".proxyPass = "http://127.0.0.1:${toString port}";
        };

        postgresql = {
          ensureDatabases = [ "bambuddy" ];

          ensureUsers = singleton {
            name = "bambuddy";
            ensureDBOwnership = true;
          };
        };

        bambuddy = {
          enable = true;
          database.url = "postgresql+asyncpg:///bambuddy?host=/run/postgresql";
        };
      };

      topology.self.services.bambuddy = {
        name = "BamBuddy";
        icon = inputs.self + "/assets/bambu.svg";
        info = domain;
      };
    };
}
