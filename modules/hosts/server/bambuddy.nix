{ moduleWithSystem, inputs, ... }: {
  flake.nixosConfigurations.server.module = moduleWithSystem (
    { config, ... }:
    { lib, ... }@nixos:
    let
      inherit (lib.lists) singleton;
      inherit (lib.meta) getExe;
      domain = "bambuddy.${nixos.config.networking.domain}";
      user = "bambuddy";
      group = "bambuddy";
      dataDir = "/var/lib/bambuddy";
      logDir = "${dataDir}/log";
    in
    {
      services = {
        nginx.virtualHosts.${domain} = {
          enableACME = true;
          forceSSL = true;
          locations."/".proxyPass = "http://127.0.0.1:8000";
        };

        postgresql = {
          ensureDatabases = [ "bambuddy" ];

          ensureUsers = singleton {
            name = "bambuddy";
            ensureDBOwnership = true;
          };
        };
      };

      users = {
        users.${user} = {
          description = "BamBuddy";
          inherit group;
          home = dataDir;
          isSystemUser = true;
        };

        groups.${group} = { };
      };

      systemd = {
        tmpfiles.settings.bambuddyDirs = {
          ${dataDir}.d = {
            mode = "750";
            inherit user group;
          };

          ${logDir}.d = {
            mode = "750";
            inherit user group;
          };
        };

        services.bambuddy = {
          description = "Self-hosted command center for Bambu Lab";
          wantedBy = [ "multi-user.target" ];

          after = [
            "network.target"
            "network-online.target"
          ];

          requires = [ "network-online.target" ];

          environment = {
            DATABASE_URL = "postgresql+asyncpg:///bambuddy?host=/run/postgresql";
            DATA_DIR = dataDir;
            LOG_DIR = logDir;
            TZ = nixos.config.time.timeZone;
          };

          serviceConfig = {
            User = user;
            Group = group;
            WorkingDirectory = dataDir;
            ExecStart = getExe config.packages.bambuddy;
            Restart = "on-failure";
            RestartSec = "5";
            TimeoutStopSec = "10";
            NoNewPrivileges = true;
            PrivateTmp = true;
            ProtectSystem = "strict";
            ProtectHome = true;

            ReadWritePaths = [
              dataDir
              logDir
            ];
          };
        };
      };

      topology.self.services.bambuddy = {
        name = "BamBuddy";
        icon = inputs.self.outPath + "/assets/bambu.svg";
        info = domain;
      };
    }
  );
}
