{
  lib,
  config,
  pkgs,
  inputs,
  ...
}:
with lib; let
  cfg = config.modules.niri;
  monitorCfg = config.modules.host.monitors;
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
          "Mod+Space".action.spawn = [
            "noctalia-shell"
            "ipc"
            "call"
            "launcher"
            "toggle"
          ];
          "Mod+Shift+C".action = close-window;

          "Mod+Left".action = focus-column-left;
          "Mod+Right".action = focus-column-right;
          "Mod+Alt+Right".action = focus-monitor-right;
          "Mod+Alt+Left".action = focus-monitor-left;
          "Mod+Alt+Up".action = focus-workspace-up;
          "Mod+Alt+Down".action = focus-workspace-down;
          "Mod+F".action = fullscreen-window;
          "Mod+V".action = toggle-window-floating;
          "Mod+O".action = toggle-overview;
          "Mod+Shift+Right".action = move-column-right;
          "Mod+Shift+Left".action = move-column-left;
          "Mod+Shift+Up".action = move-column-to-workspace-up;
          "Mod+Shift+Down".action = move-column-to-workspace-down;
        };

        environment = {
          QT_QPA_PLATFORM = "wayland";
          NIXOS_OZONE_WL = "1";
          ELECTRON_OZONE_PLATFORM_HINT = "auto";
        };

        # Eventually set this to true
        hotkey-overlay.skip-at-startup = true;
        clipboard.disable-primary = true;

        # List of commands to run at startup.
        spawn-at-startup = [
          {argv = ["systemctl" "--user" "import-environment" "NIXOS_OZONE_WL" "ELECTRON_OZONE_PLATFORM_HINT" "QT_QPA_PLATFORM"];}
          # Maybe move this into a systemd service eventually
          {argv = ["${pkgs.hyprpolkitagent}/libexec/hyprpolkitagent"];}
          # TODO: If I ever feel the need to have multiple possible shells I'm going to need to make this dynamic
          {command = ["noctalia-shell"];}
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

        outputs = builtins.listToAttrs (
          map (monitor: {
            name = monitor.name;
            value = {
              enable = true;
              mode = {
                height = monitor.mode.height;
                width = monitor.mode.width;
                refresh = monitor.mode.refreshRate;
              };
              position = {
                x = monitor.position.x;
                y = monitor.position.y;
              };
            };
          })
          monitorCfg
        );
      };
    };

    home.packages = with pkgs; [
      xwayland-satellite
    ];

    xdg = {
      configFile."xdg-desktop-portal/portals.conf".text = ''
        [preferred]
        default=gtk
        org.freedesktop.impl.portal.FileChooser=gtk
        org.freedesktop.impl.portal.Screencast=gnome
        org.freedesktop.impl.portal.Secret=gnome-keyring
      '';
      portal = {
        enable = true;
        extraPortals = with pkgs; [
          xdg-desktop-portal-gtk
        ];
      };
    };
  };
}
