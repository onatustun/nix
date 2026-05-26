{
  flake.modules.nixos.calibre-web =
    {
      lib,
      config,
      pkgs,
      ...
    }:
    let
      inherit (lib.strings) hasPrefix concatStringsSep optionalString;
      inherit (lib.options) mkEnableOption mkPackageOption mkOption;
      inherit (lib.types)
        str
        port
        nullOr
        path
        ;
      inherit (lib.modules) mkIf;
      inherit (lib.lists) optionals optional;
      inherit (lib.meta) getExe getExe';
      inherit (lib.attrsets) optionalAttrs;
      inherit (pkgs) writeShellScript;

      cfg = config.services.calibre-web;
      dataDir = if hasPrefix "/" cfg.dataDir then cfg.dataDir else "/var/lib/${cfg.dataDir}";
    in
    {
      options.services.calibre-web = {
        enable = mkEnableOption "Calibre-Web";
        package = mkPackageOption pkgs "calibre-web" { };
        calibrePackage = mkPackageOption pkgs "calibre" { };

        listen = {
          ip = mkOption {
            type = str;
            default = "::1";
            description = "IP address that Calibre-Web should listen on.";
          };

          port = mkOption {
            type = port;
            default = 8083;
            description = "Listen port for Calibre-Web.";
          };
        };

        dataDir = mkOption {
          type = str;
          default = "calibre-web";

          description = ''
            Where Calibre-Web stores its data.
            Either an absolute path, or a directory name below {file}`/var/lib`.
          '';
        };

        user = mkOption {
          type = str;
          default = "calibre-web";
          description = "User account under which Calibre-Web runs.";
        };

        group = mkOption {
          type = str;
          default = "calibre-web";
          description = "Group account under which Calibre-Web runs.";
        };

        openFirewall = mkEnableOption "Open ports in the firewall for the server.";

        options = {
          calibreLibrary = mkOption {
            type = nullOr path;
            default = null;
            description = "Path to Calibre library.";
          };

          enableBookConversion = mkEnableOption "Configure path to Calibre's ebook-convert in the DB.";
          enableBookUploading = mkEnableOption "Allow books to be uploaded via Calibre-Web UI.";
          enableComics = mkEnableOption "comic book support";
          enableGdrive = mkEnableOption "Google Drive integration";
          enableGmail = mkEnableOption "Gmail OAuth2 email support";
          enableKepubify = mkEnableOption "kepub conversion support";
          enableLdap = mkEnableOption "LDAP authentication support";
          enableMetadata = mkEnableOption "online metadata and cover fetching";
          enableOAuth = mkEnableOption "OAuth authentication support";

          reverseProxyAuth = {
            enable = mkEnableOption "Enable authorization using auth proxy.";

            header = mkOption {
              type = str;
              default = "";
              description = "Auth proxy header name.";
            };
          };

          kobo = {
            enableSync = mkEnableOption "Kobo sync support";

            externalPort = mkOption {
              type = port;
              default = 443;

              description = ''
                External port used in Kobo sync URLs. Should match the port
                your reverse proxy listens on (usually 443 for HTTPS).
              '';
            };

            trustedProxy = mkOption {
              type = str;
              default = "";

              description = ''
                Hostname of the trusted reverse proxy. Required for correct
                https scheme generation in Kobo sync URLs.
              '';
            };
          };
        };
      };

      config = mkIf cfg.enable (
        let
          finalPackage = cfg.package.overrideAttrs (prevAttrs: {
            propagatedBuildInputs =
              (prevAttrs.propagatedBuildInputs or [ ])
              ++ optionals cfg.options.enableComics cfg.package.optional-dependencies.comics
              ++ optionals cfg.options.enableGdrive cfg.package.optional-dependencies.gdrive
              ++ optionals cfg.options.enableGmail cfg.package.optional-dependencies.gmail
              ++ optionals cfg.options.enableLdap cfg.package.optional-dependencies.ldap
              ++ optionals cfg.options.enableMetadata cfg.package.optional-dependencies.metadata
              ++ optionals cfg.options.enableOAuth cfg.package.optional-dependencies.oauth
              ++ optionals cfg.options.kobo.enableSync cfg.package.optional-dependencies.kobo;
          });

          appDb = "${dataDir}/app.db";
          calibreWebCmd = "${getExe finalPackage} -p ${appDb} -g ${dataDir}/gdrive.db";

          settings = concatStringsSep ", " (
            [
              "config_port = ${toString cfg.listen.port}"
              "config_uploading = ${if cfg.options.enableBookUploading then "1" else "0"}"
              "config_allow_reverse_proxy_header_login = ${
                if cfg.options.reverseProxyAuth.enable then "1" else "0"
              }"
              "config_reverse_proxy_login_header_name = '${cfg.options.reverseProxyAuth.header}'"
              "config_kobo_sync = ${if cfg.options.kobo.enableSync then "1" else "0"}"
            ]
            ++ optionals cfg.options.kobo.enableSync [
              "config_external_port = ${toString cfg.options.kobo.externalPort}"
            ]
            ++ optional (
              cfg.options.kobo.trustedProxy != ""
            ) "config_trustedhosts = '${cfg.options.kobo.trustedProxy}'"
            ++ optional (
              cfg.options.calibreLibrary != null
            ) "config_calibre_dir = '${cfg.options.calibreLibrary}'"
            ++ optionals cfg.options.enableBookConversion [
              "config_converterpath = '${getExe' cfg.calibrePackage "ebook-convert"}'"
              "config_binariesdir = '${cfg.calibrePackage}/bin/'"
            ]
            ++ optional cfg.options.enableKepubify "config_kepubifypath = '${getExe' pkgs.kepubify "kepubify"}'"
          );
        in
        {
          users = {
            users = mkIf (cfg.user == "calibre-web") {
              calibre-web = {
                description = "calibre-web";
                inherit (cfg) group;
                home = dataDir;
                isSystemUser = true;
              };
            };

            groups = mkIf (cfg.group == "calibre-web") { ${cfg.group} = { }; };
          };

          networking.firewall = mkIf cfg.openFirewall { allowedTCPPorts = [ cfg.listen.port ]; };

          systemd = {
            tmpfiles.settings = {
              calibre-web.${dataDir}.d = {
                mode = "0700";
                inherit (cfg) user group;
              };
            }
            // optionalAttrs (cfg.options.calibreLibrary != null) {
              calibre-web-library.${cfg.options.calibreLibrary}.d = {
                mode = "0750";
                inherit (cfg) user group;
              };
            };

            services.calibre-web = {
              description = "Web app for browsing, reading and downloading eBooks stored in a Calibre database";
              wantedBy = [ "multi-user.target" ];
              after = [ "network.target" ];

              # book cover cache defaults to a path under /nix/store/ without this
              environment.CACHE_DIR = "/var/cache/calibre-web";

              serviceConfig = {
                User = cfg.user;
                Group = cfg.group;

                ExecStartPre = writeShellScript "calibre-web-pre-start" (
                  ''
                    __RUN_MIGRATIONS_AND_EXIT=1 ${calibreWebCmd}
                    ${getExe' pkgs.sqlite "sqlite3"} ${appDb} "update settings set ${settings}"
                  ''
                  + optionalString (cfg.options.calibreLibrary != null) ''
                    test -f "${cfg.options.calibreLibrary}/metadata.db" || { echo "Invalid Calibre library"; exit 1; }
                  ''
                );

                ExecStart = "${calibreWebCmd} -i ${cfg.listen.ip}";
                Restart = "on-failure";

                CacheDirectory = "calibre-web";
                CacheDirectoryMode = "0750";

                ReadWritePaths = [
                  dataDir
                ]
                ++ optional (cfg.options.calibreLibrary != null) cfg.options.calibreLibrary;

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
              }
              // optionalAttrs (!(hasPrefix "/" cfg.dataDir)) { StateDirectory = cfg.dataDir; };
            };
          };
        }
      );

      meta.maintainers = with lib.maintainers; [ onatustun ];
    };
}
