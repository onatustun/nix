{
  flake.modules.homeManager.tmux =
    {
      pkgs,
      lib,
      config,
      ...
    }:
    let
      inherit (pkgs.writers) writeText;
      inherit (lib.meta) getExe;
    in
    {
      programs.nushell.extraConfig = "source ${writeText "tmux.nu" ''
        if (
          ($env.TMUX? | is-empty)
          and ($env.NO_TMUX? | is-empty)
          and ($env.SSH_CONNECTION? | is-empty)
        ) {
          ^${getExe config.programs.tmux.package} new-session -A -s $env.USER
        }
      ''}";
    };
}
