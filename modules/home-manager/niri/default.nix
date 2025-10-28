{ lib, config, pkgs, inputs, ... }: 
with lib;
let cfg = config.modules.niri;
in {
  options.modules.niri = { 
      enable = mkEnableOption "niri";
  };

  imports = [
        inputs.niri.homeModules.niri
  ];

  config = mkIf cfg.enable {
    programs.niri = {
        enable = true;
        settings = {
            binds = with config.lib.niri.actions; {
                "Mod+Shift+E".action = quit;
                "Mod+Return".action.spawn = "alacritty";
                "Mod+Space".action = spawn "sh" "-c" "fuzzel";
                "Mod+Shift+S".action = screenshot;
                "Mod+Shift+C".action = close-window;

                "Mod+Left".action = focus-column-left;
                "Mod+Right".action = focus-column-right;
                "Mod+Alt+Right".action = focus-monitor-right;
                "Mod+Alt+Left".action = focus-monitor-left;
                "Mod+Alt+Up".action = focus-workspace-up;
                "Mod+Alt+Down".action = focus-workspace-down;
                # "Mod+Up".action = focus-column-up;
                # "Mod+Down".action = focus-column-down;
                
                "Mod+F".action = fullscreen-window; 
                "Mod+V".action = toggle-window-floating;
                "Mod+O".action = toggle-overview;

                "Mod+Shift+Right".action = move-column-right;
                "Mod+Shift+Left".action = move-column-left;
                "Mod+Shift+Up".action = move-column-to-workspace-up;
                "Mod+Shift+Down".action = move-column-to-workspace-down;
            };

            environment = {
            };

            # Eventually set this to true
            hotkey-overlay.skip-at-startup = false;
            clipboard.disable-primary = true;

            # List of commands to run at startup. Wallpaper?
            spawn-at-startup = [
                # Maybe move this into a systemd service eventually
                { argv = ["${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1"]; }
                { argv = ["${pkgs.xwayland-satellite}"]; }
                # { argv = ["swaybg" "--image" "/path/to/wallpaper.jpg"]; }
                # { argv = ["~/.config/niri/scripts/startup.sh"]; }
            ];

            workspaces = {
                gaming = {};
            };

            input = {
                mod-key = "Super";

                warp-mouse-to-focus = {
                    enable = true;
                };
            };

            outputs = {
                "DP-1" = {
                    mode = {
                        height = 1440;
                        width = 2560;
                    };
                    position = {
                        x = 1920;
                        y = 0;
                    };
                };
                "DP-2" = {
                    mode = {
                        height = 1080;
                        width = 1920;
                    };
                    position = {
                        x = 0;
                        y = 0;
                    };
                };
            };

        };
    };

    programs.fuzzel = {
        enable = true;
    };

    home.packages = with pkgs; [
        xwayland-satellite
        gnome-keyring
    ];

    xdg.portal = {
        enable = lib.mkForce true;

        extraPortals = with pkgs; [
            xdg-desktop-portal-gtk
            xdg-desktop-portal-wlr
        ]; 
    };
  };
}
