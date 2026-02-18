{
  lib,
  config,
  pkgs,
  inputs,
  ...
}:
with lib; let
  cfg = config.modules.tmux;
in {
  options.modules.tmux = {
    enable = mkOption {
      description = "Enable tmux";
      type = types.bool;
      default = false;
    };
  };

  config = mkIf cfg.enable {
    programs.tmux = {
      enable = true;
      historyLimit = 100000;
      prefix = "C-Space";
      baseIndex = 1;
      escapeTime = 0;
      keyMode = "vi";
      mouse = true;
      # TODO: Pull this from the user's config
      shell = "${pkgs.zsh}/bin/zsh";
      plugins = with pkgs.tmuxPlugins; [
        vim-tmux-navigator
        yank
      ];
      extraConfig = ''
        set-option -sa terminal-overrides ",xterm*:Tc"
        bind v copy-mode
        bind-key -T copy-mode-vi v send-keys -X begin-selection
        bind-key -T copy-mode-vi C-v send-keys -X rectangle-toggle
        bind-key -T copy-mode-vi y send-keys -X copy-selection-and-cancel
        bind c new-window -c "#{pane_current_path}"
        bind k kill-window
      '';
    };
  };
}
