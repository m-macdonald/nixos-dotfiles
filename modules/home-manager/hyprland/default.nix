{
  lib,
  config,
  pkgs,
  inputs,
  ...
}:
with lib; let
  cfg = config.modules.hyprland;
  # swww-init = pkgs.writeShellScriptBin "swww-init" ''
  #   #! /usr/bin/env bash
  #   files=(/mnt/nas/media/images/pixiv/*)
  #
  #   random_background=''${files[RANDOM % ''${#files[@]}]}
  #
  #   if ! ps -ef | grep -v grep | grep -q "swww-daemon"; then
  #     swww init
  #   fi
  #   echo ''$random_background
  #   swww img "$random_background"
  # '';
in {
  options.modules.hyprland = {
    enable = mkEnableOption "hyprland";
  };

  config = mkIf cfg.enable {
    wayland.windowManager.hyprland = {
      enable = true;
      xwayland.enable = true;
      systemd.enable = true;
      package = null;
      portalPackage = null;
      settings = {
        "$mod" = "SUPER";
        env = [
          "QT_QPA_PLATFORM,xcb"
        ];
        monitor = [
          "DP-1,2560x1440@144,1920x0,1"
          "DP-2,1920x1080@144,0x0,1"
        ];
        workspace = [
          "DP-2,1"
          "DP-1,2"
        ];
        # "exec-once" = "swww-init";
        input = {
          kb_layout = "us";
          follow_mouse = 1;
          sensitivity = 0;
        };
        general = {
          gaps_in = 5;
          gaps_out = 5;
          border_size = 1;
          "col.active_border" = "0xff7D4045";
          "col.inactive_border" = "0xff382D2E";
          no_border_on_floating = false;
          layout = "dwindle";
        };
        bind =
          [
            # Common utilities
            "$mod SHIFT, M, exit"
            "$mod, Return, exec, alacritty"
            "$mod SHIFT, C, killactive"
            "$mod, SPACE, exec, rofi -show drun"
            # Move window focus
            "$mod, left, movefocus, l"
            "$mod, right, movefocus, r"
            "$mod, up, movefocus, u"
            "$mod, down, movefocus, d"
            # Utility bindings
            "$mod, V, togglefloating"
            "$mod, F, fullscreen, 1"
          ]
          # Workspace utilities
          ++ (
            builtins.concatLists (builtins.genList (
                x: let
                  ws = let
                    c = (x + 1) / 10;
                  in
                    builtins.toString (x + 1 - (c * 10));
                in [
                  "$mod, ${ws}, workspace, ${toString (x + 1)}"
                  "ALT, ${ws}, movetoworkspace, ${toString (x + 1)}"
                ]
              )
              10)
          );
        bindm = [
          "$mod, mouse:272, movewindow"
          "$mod, mouse:273, resizewindow"
        ];
        debug = {
          "full_cm_proto" = true;
        };
      };
    };

    home.sessionVariables.NIXOS_OZONE_WL = "1";
    home = {
      packages = with pkgs; [
        # swww
        eww
        # swww-init
        rofi
        #Snipping tool
        # flameshot
        # grim
      ];
    };
  };
}
