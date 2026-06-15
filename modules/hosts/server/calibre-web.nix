{ inputs, ... }: {
  flake.nixosConfigurations.server.module =
    {
      lib,
      pkgs,
      config,
      ...
    }:
    let
      inherit (lib.meta) getExe getExe';
      inherit (lib.strings) concatStringsSep;
      inherit (pkgs) writeShellScript;
      rootDomain = config.networking.domain;
      domain = "books.${rootDomain}";
      ip = "127.0.0.1";
      port = 8083;
      user = "calibre-web";
      group = "calibre-web";
      dataDir = "/var/lib/calibre-web";
      package = pkgs.calibre-web;

      finalPackage = package.overrideAttrs (prevAttrs: {
        propagatedBuildInputs =
          (prevAttrs.propagatedBuildInputs or [ ])
          ++ package.optional-dependencies.metadata
          ++ package.optional-dependencies.kobo;
      });

      appDb = "${dataDir}/app.db";
      calibreWebCmd = "${getExe finalPackage} -p ${appDb} -g ${dataDir}/gdrive.db";
      calibreLibrary = "${dataDir}/library";
      calibrePackage = pkgs.calibre;
    in
    {
      services.nginx.virtualHosts.${domain} = {
        enableACME = true;
        forceSSL = true;
        extraConfig = "large_client_header_buffers 4 16k;";

        locations."/" = {
          proxyPass = "http://${ip}:${toString port}";

          extraConfig = ''
            client_max_body_size    0;
            proxy_set_header        X-Forwarded-Proto https;
            proxy_set_header        X-Scheme https;
            proxy_buffer_size       128k;
            proxy_buffers           4 256k;
            proxy_busy_buffers_size 256k;
          '';
        };
      };

      users = {
        users.${user} = {
          description = "calibre-web";
          inherit group;
          home = dataDir;
          isSystemUser = true;
        };

        groups.${group} = { };
      };

      systemd = {
        tmpfiles.settings = {
          calibre-web.${dataDir}.d = {
            mode = "0700";
            inherit user group;
          };

          calibre-web-library.${calibreLibrary}.d = {
            mode = "0750";
            inherit user group;
          };
        };

        services.calibre-web = {
          description = "Web app for browsing, reading and downloading eBooks stored in a Calibre database";
          wantedBy = [ "multi-user.target" ];
          after = [ "network.target" ];
          environment.CACHE_DIR = "/var/cache/calibre-web";

          serviceConfig = {
            User = user;
            Group = group;

            ExecStartPre = writeShellScript "calibre-web-pre-start" ''
              __RUN_MIGRATIONS_AND_EXIT=1 ${calibreWebCmd}
              ${getExe pkgs.sqlite} ${appDb} "update settings set ${
                concatStringsSep ", " [
                  "config_binariesdir = '${calibrePackage}/bin/'"
                  "config_calibre_dir = '${calibreLibrary}'"
                  "config_converterpath = '${getExe' calibrePackage "ebook-convert"}'"
                  "config_external_port = 443"
                  "config_kepubifypath = '${getExe' pkgs.kepubify "kepubify"}'"
                  "config_kobo_sync = 1"
                  "config_port = ${toString port}"
                  "config_trustedhosts = '${domain}'"
                  "config_uploading = 1"
                ]
              }"
              test -f "${calibreLibrary}/metadata.db" || { echo "Invalid Calibre library"; exit 1; }
            '';

            ExecStart = "${calibreWebCmd} -i ${ip}";
            Restart = "on-failure";

            CacheDirectory = "calibre-web";
            CacheDirectoryMode = "0750";

            ReadWritePaths = [
              dataDir
              calibreLibrary
            ];

            NoNewPrivileges = true;
            ProtectSystem = "strict";
            PrivateTmp = true;
            PrivateDevices = true;
            PrivateIPC = true;
            ProtectHome = true;
            ProtectHostname = true;
            ProtectClock = true;
            ProtectKernelTunables = true;
            ProtectKernelModules = true;
            ProtectKernelLogs = true;
            ProtectControlGroups = true;
            ProtectProc = "invisible";
            ProcSubset = "pid";
            LockPersonality = true;
            MemoryDenyWriteExecute = true;
            RestrictSUIDSGID = true;
            RestrictRealtime = true;
            RestrictNamespaces = true;
            RemoveIPC = true;
            SystemCallArchitectures = "native";
            CapabilityBoundingSet = "";
            AmbientCapabilities = "";

            RestrictAddressFamilies = [
              "AF_INET"
              "AF_INET6"
              "AF_UNIX"
              "AF_NETLINK"
            ];

            SystemCallFilter = [
              "~@obsolete"
              "~@privileged"
              "~@raw-io"
              "~@resources"
              "~@mount"
              "~@debug"
              "~@cpu-emulation"
            ];
          };
        };
      };

      topology.self.services.calibre-web = {
        name = "Calibre Web";
        icon = inputs.self + "/assets/calibre.svg";
        info = domain;
      };
    };
}
