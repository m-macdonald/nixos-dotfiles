{
  config,
  lib,
  inputs,
  ...
}:
with lib; let
  cfg = config.modules.noctalia;
in {
  options.modules.noctalia = {
    enable = mkEnableOption "noctalia";
    wifi = mkEnableOption "wifi";
  };

  imports = [
    inputs.noctalia.homeModules.default
  ];

  config = mkIf cfg.enable {
    programs.noctalia = {
      enable = true;
      settings = {
        appLauncher = {
          enableClipboardHistory = true;
        };
        bar = {
          backgroundOpacity = 0;
          density = "compact";
          exclusive = true;
          floating = true;
          frameRadius = 12;
          frameThickness = 8;
          hideOnOverview = false;
          marginHorizontal = 10;
          marginVertical = 2;
          position = "top";
          showCapsule = false;
          showOutline = false;
          useSeparateOpacity = true;
          widgets = {
            center = ["media"];
            end = ["group:g1" "network" "bluetooth" "volume" "brightness" "battery" "tray" "notifications"];
            margin_ends = 100;
            start = ["workspaces"];
            capsule_group = [
              {
                fill = "surface";
                id = "g1";
                members = ["date" "clock"];
                opacity = 1.0;
                padding = 6.0;
              }
            ];
            left = [
              {
                colorizeDistroLogo = true;
                id = "ControlCenter";
                useDistroLogo = true;
              }
              {
                id = "Launcher";
              }
            ];
            right = [
              {
                displayMode = "onhover";
                id = "Network";
              }
              {
                displayMode = "onhover";
                id = "Bluetooth";
              }
              {
                alwaysShowPercentage = false;
                hideIfIdle = false;
                hideIfNotDetected = true;
                id = "Battery";
                warningThreshold = 30;
              }
              {
                formatHorizontal = "HH:mm";
                formatVertical = "HH mm";
                id = "Clock";
                tooltipFormat = "HH:mm ddd, MMM dd";
                useMonospacedFont = true;
                usePrimaryColor = true;
              }
              {
                colorizeIcons = true;
                drawerEnabled = true;
                hidePassive = false;
                id = "Tray";
              }
            ];
          };
        };
        calendar = {
        };
        controlCenter = {
          position = "center";
        };
        control_center = {
          shortcuts = [
            {
              type = "wifi";
            }
            {
              type = "bluetooth";
            }
            {
              type = "nightlight";
            }
            {
              type = "notification";
            }
            {
              type = "power_profile";
            }
            {
              type = "audio";
            }
          ];
        };
        desktop_widgets = {
          schema_version = 2;
          widget_order = [];
          grid = {
            cell_size = 16;
            major_interval = 4;
            visible = true;
          };
          widget = {
          };
        };
        dock = {
          auto_hide = true;
          enabled = true;
          icon_size = 35;
          position = "bottom";
          reserve_space = false;
        };
        location = {
          auto_locate = true;
          name = "Georgia, US";
          useFahrenheit = true;
          weatherEnabled = true;
        };
        network = {
          wifiEnabled = true;
        };
        nightlight = {
          enabled = true;
        };
        notifications = {
          enabled = true;
        };
        shell = {
          clipboard_auto_paste = "ctrl_shift_v";
          font_family = "DroidSansM Nerd Font";
          animation = {
            speed = 1.8000000268220901;
          };
          panel = {
            control_center_placement = "floating";
            open_near_click_control_center = true;
            open_near_click_session = true;
            open_near_click_wallpaper = true;
            session_placement = "floating";
            wallpaper_placement = "floating";
          };
        };
        theme = {
          mode = "dark";
          source = "wallpaper";
          wallpaper_scheme = "m3-content";
        };
        wallpaper = {
          transition_duration = 500;
          transition_on_startup = true;
         };
        weather = {
          unit = "imperial";
        };
        widget = {
          tray = {
            drawer = true;
          };
        };
      };
    };
  };
}
