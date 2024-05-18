{ lib, config, pkgs, inputs, ... }: 
with lib;
let cfg = config.modules.hyprland;
  swww-init = pkgs.writeShellScriptBin "swww-init" ''
    #! /usr/bin/env bash
    files=(/mnt/nas/media/images/pixiv/*)

    random_background=''${files[RANDOM % ''${#files[@]}]}

    if ! ps -ef | grep -v grep | grep -q "swww-daemon"; then
      swww init
    fi
    echo ''$random_background
    swww img "$random_background"
  '';
  hyprland-init = pkgs.writeShellScriptBin "hyprland-init" ''
    xwaylandvideobridge
    swww-init
  '';
in {
  options.modules.hyprland = { 
      enable = mkEnableOption "hyprland";
      enableNvidia = mkEnableOption "Enable NVIDIA-specific patches.";
  };

  imports = [
    inputs.hyprland.homeManagerModules.default
  ];

  config = mkIf cfg.enable {
    wayland.windowManager.hyprland = {
      enable = true;
      enableNvidiaPatches = cfg.enableNvidia;
      systemd = {
          enable = true;
          # variables = [ "--all" ];
      };
      settings = {
        "$mod" = "SUPER";
        env =
            [
                "XDG_SESSION_DESKTOP,Hyprland"
                "XDG_SESSION_TYPE,wayland"
                "XDG_CURRENT_DESKTOP,Hyprland"
                "QT_QPA_PLATFORM,wayland"
                "GDK_BACKEND,wayland"
                "MOZ_ENABLE_WAYLAND,1"
                "NIXOS_OZONE_WL,1"
            ];
        monitor =
            [
                "DP-1,2560x1440@144,1920x0,1"
                "DP-2,1920x1080@144,0x0,1"
            ];
        workspace =
            [
                "DP-2,1"
                "DP-1,2"
            ];
        "exec-once" = "hyprland-init";
        input = 
            {
                kb_layout = "us";
                follow_mouse = 1;
                sensitivity = 0;
            };
        general = 
            {
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
        bindm = 
            [
                "$mod, mouse:272, movewindow"
                "$mod, mouse:273, resizewindow"
            ];
      };
    };
    home = {
      packages = with pkgs; [
        swww
        eww-wayland
        hyprland-init
        swww-init

        # For screensharing
        xwaylandvideobridge
      ];
    };
  };
}
