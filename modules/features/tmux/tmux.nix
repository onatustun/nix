{
  flake.modules.homeManager.tmux = { config, ... }: {
    programs.tmux = {
      enable = true;
      baseIndex = 1;
      customPaneNavigationAndResize = true;
      escapeTime = 0;
      focusEvents = true;
      keyMode = "vi";
      mouse = true;
      terminal = "tmux-256color";

      extraConfig = /* conf */ ''
        set -g extended-keys on
        set -ag terminal-features ",xterm-ghostty:extkeys"
        set -ag terminal-overrides ",xterm-256color:RGB"
        set -ag terminal-overrides ",xterm-ghostty:RGB"

        set -g popup-style "default"
        set -g popup-border-style "default"

        set -g default-command "${config.home.sessionVariables.SHELL}"

        set -g status-position top
        set -g status-justify absolute-centre
        set -g status-right ""
        set -g status-left "#S"
        setw -g window-status-current-format "#I:#W "

        bind-key t display-popup -w 80% -h 80% -d '#{pane_current_path}' ${config.home.sessionVariables.SHELL} --login
        bind-key b set-option status
        bind-key c new-window -c "#{pane_current_path}"
        bind-key % split-window -h -c "#{pane_current_path}"
        bind-key '"' split-window -v -c "#{pane_current_path}"
      '';
    };
  };
}
