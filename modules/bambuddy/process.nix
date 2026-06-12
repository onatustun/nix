{ inputs, ... }: {
  imports = [ (inputs.process-compose-flake + "/nix/flake-module.nix") ];

  perSystem =
    {
      pkgs,
      lib,
      config,
      ...
    }:
    let
      dbName = "bambuddy";
      inherit (pkgs) writeShellApplication;
      inherit (lib.meta) getExe;
      inherit (config.packages) bambuddy;
    in
    {
      process-compose.bambuddy-dev = { config, ... }: {
        imports = [ (inputs.services-flake + "/nix/process-compose") ];

        services.postgres.pg = {
          enable = true;
          initialDatabases = [ { name = dbName; } ];
        };

        settings.processes.bambuddy = {
          command = writeShellApplication {
            name = "bambuddy-dev";
            runtimeInputs = [ pkgs.coreutils ];

            text = ''
              set -euo pipefail

              run_dir="$(mktemp -d)"
              trap 'rm -rf "$run_dir"' EXIT

              mkdir -p "$run_dir/bambuddy/log"
              export DATA_DIR="$run_dir/bambuddy"
              export LOG_DIR="$run_dir/bambuddy/log"

              DATABASE_URL="$(
                printf '%s' "${config.services.postgres.pg.connectionURI { inherit dbName; }}" \
                  | sed 's|^postgres://|postgresql+asyncpg://|'
              )"
              export DATABASE_URL

              exec ${getExe bambuddy}
            '';
          };

          depends_on.pg.condition = "process_healthy";

          readiness_probe.http_get = {
            host = "127.0.0.1";
            port = 8000;
            path = "/";
          };
        };
      };
    };
}
