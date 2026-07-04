{
  flake.modules.homeManager.tmux =
    {
      lib,
      pkgs,
      config,
      ...
    }:
    let
      inherit (lib.meta) getExe;
      inherit (pkgs.writers) writeNuBin;
      tmux = getExe config.programs.tmux.package;
    in
    {
      programs.tmux.extraConfig = "bind-key f display-popup -w 80% -h 80% -E ${
        getExe
        <| writeNuBin "tmux-sessions.nu" /* nu */ ''
          def main [selected?: string] {
            let selected = if ($selected | is-not-empty) {
              $selected
            } else {
              let potential_dirs = [
                $env.HOME
                ($env.HOME | path join "Documents")
                ($env.HOME | path join "Projects")
              ]

              let search_dirs = $potential_dirs | where {|dir| $dir | path exists }

              if ($search_dirs | is-not-empty) {
                let selected_relative = $search_dirs
                | each {|dir| ^${getExe config.programs.fd.package} --max-depth 1 --type d -H . $dir }
                | flatten
                | each {|path| $path | str trim --right --char "/" | str replace $"($env.HOME)/" "" }
                | str join (char newline)
                | ^${getExe config.programs.skim.package} --margin 10% --color=bw

                if ($selected_relative | is-not-empty) {
                  $env.HOME | path join $selected_relative
                } else {
                  null
                }
              } else {
                null
              }
            }

            if ($selected | is-empty) {
              exit 0
            }

            let selected = $selected | str trim --right --char "/"

            let selected_name = $selected
            | path basename
            | str downcase
            | str replace --regex --all "[ .]+" "_"
            | str replace --regex --all "_{2,}" "_"
            | str trim --right --char "_"

            let session_check = do { ^${tmux} has-session -t $"=($selected_name)" } | complete
            let current_session = do { ^${tmux} display-message -p "#S" } | complete | get stdout | str trim

            if $current_session == $selected_name {
              ^${tmux} send-keys $"cd ($selected)" Enter
            } else {
              if $session_check.exit_code != 0 {
                ^${tmux} new-session -ds $selected_name -c $selected
              }

              ^${tmux} switch-client -t $"=($selected_name)"
            }
          }
        ''
      }";
    };
}
