{ inputs, ... }: {
  perSystem =
    {
      pkgs,
      lib,
      config,
      ...
    }:
    let
      dbName = "bambuddy";
      inherit (pkgs.writers) writeNuBin;
      inherit (lib.meta) getExe;
      inherit (config.packages) bambuddy;
    in
    {
      process-compose.bambuddy-dev = { config, ... }: {
        imports = [ (inputs.services-flake.outPath + "/nix/process-compose") ];

        services.postgres.pg = {
          enable = true;
          initialDatabases = [ { name = dbName; } ];
        };

        settings.processes.bambuddy = {
          command = writeNuBin "bambuddy-dev.nu" /* nu */ ''
            let data_dir = ($env.PWD)/data/bambuddy
            let log_dir = ($data_dir)/log

            mkdir $log_dir

            with-env {
              DATA_DIR: $data_dir
              LOG_DIR: $log_dir
              DATABASE_URL: ("${
                config.services.postgres.pg.connectionURI { inherit dbName; }
              }" | str replace postgres postgresql+asyncpg)
            } {
              ^${getExe bambuddy}
            }
          '';

          depends_on.pg.condition = "process_healthy";

          readiness_probe.http_get = {
            host = "127.0.0.1";
            port = 8000;
          };
        };
      };
    };
}
