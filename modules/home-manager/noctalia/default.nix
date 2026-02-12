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
    enable = mkEnableOption "noctalia shell";
    wifi = mkEnableOption "wifi";
  };

  imports = [
    inputs.noctalia.homeModules.default
  ];

  config = mkIf cfg.enable {
    programs.noctalia-shell = {
      enable = true;
      settings = {
        bar = {
          density = "compact";
          position = "top";
          showOutline = false;
          showCapsule = false;
          useSeparateOpacity = true;
          backgroundOpacity = 0;
          floating = true;
          marginVertical = 2;
          marginHorizontal = 10;
          frameThickness = 8;
          frameRadius = 12;
          exclusive = true;
          hideOnOverview = false;
          widgets = {
            left = [
              {
                id = "ControlCenter";
                useDistroLogo = true;
                colorizeDistroLogo = true;
              }
              {
                id = "Launcher";
              }
            ];
            center = [
              {
                id = "Workspace";
                colorizeIcons = true;
                emptyColor = "tertiary";
                focusedColor = "primary";
                occupiedColor = "secondary";
                followFocusedScreen = false;
                groupedBorderOpacity = 1;
                hideUnoccupied = false;
                iconScale = "0.72";
                showApplications = true;
                showBadge = true;
                unfocusedIconsOpacity = 1;
              }
            ];
            right = [
              {
                id = "Network";
                displayMode = "onhover";
              }
              {
                id = "Bluetooth";
                displayMode = "onhover";
              }
              {
                id = "Battery";
                hideIfIdle = false;
                hideIfNotDetected = true;
                alwaysShowPercentage = false;
                warningThreshold = 30;
              }
              {
                id = "Clock";
                formatHorizontal = "HH:mm";
                formatVertical = "HH mm";
                tooltipFormat = "HH:mm ddd, MMM dd";
                useMonospacedFont = true;
                usePrimaryColor = true;
              }
              {
                id = "Tray";
                colorizeIcons = true;
                hidePassive = false;
                drawerEnabled = true;
              }
            ];
          };
        };
        location = {
          name = "Georgia, US";
          weatherEnabled = true;
          useFahrenheit = true;
        };
        calendar = {};
        wallpaper = {};
        appLauncher = {
          enableClipboardHistory = true;
        };
        controlCenter = {
          position = "center";
        };
        dock = {
          enabled = true;
          position = "bottom";
        };
        network = {
          # TODO: Make this conditional at some point. My desktop has no use for it.
          wifiEnabled = true;
        };
        notifications = {
          enabled = true;
        };
      };
    };
  };
}
