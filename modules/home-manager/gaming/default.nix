{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.modules.gaming;

  primaryMonitor = lib.findFirst (m: m.primary) null config.modules.host.monitors;

  gamescoperun = pkgs.writeShellScriptBin "gamescoperun" ''
    if [ -n "$GAMESCOPE_WAYLAND_DISPLAY" ]; then
        echo "[gamescoperun] already inside Gamescope session, running directly..."
        exec "$@"
    fi

    if [ $# -eq 0 ]; then
        echo "Usage: gamescoperun <command> [args...]"
        exit 1
    fi

    export AMD_VULKAN_ICD=RADV
    export DISABLE_LAYER_AMD_SWITCHABLE_GRAPHICS_1=1
    export DISABLE_LAYER_NV_OPTIMUS_1=1
    export GAMESCOPE_WAYLAND_DISPLAY=gamescope-0
    export PROTON_ADD_CONFIG=sdlinput,wayland
    export PROTON_ENABLE_WAYLAND=1
    export RADV_PERFTEST=aco
    export SDL_VIDEODRIVER=wayland
    export ENABLE_GAMESCOPE_WSI=1

    exec ${lib.getExe pkgs.gamescope} \
        --backend sdl \
        --fade-out-duration 200 \
        --fullscreen \
        --immediate-flips \
        --nested-refresh ${toString primaryMonitor.mode.refreshRate} \
        --output-height ${toString primaryMonitor.mode.height} \
        --output-width ${toString primaryMonitor.mode.width} \
        --rt \
        "$@"
  '';

  heroic = pkgs.writeShellScriptBin "heroic-launcher" ''
    exec ${lib.getExe pkgs.heroic} "$@"
  '';
  heroic-gamescope = pkgs.writeShellScriptBin "heroic-gamescope" ''
    exec ${gamescoperun}/bin/gamescoperun ${heroic}/bin/heroic "$@"
  '';
  steam = pkgs.writeShellScriptBin "steam" ''
     exec env STEAM_USE_WAYLAND=1 /run/current-system/sw/bin/steam "$@"
  '';
  steam-gamescope = pkgs.writeShellScriptBin "steam-gamescope" ''
    exec ${gamescoperun}/bin/gamescoperun ${steam}/bin/steam
  '';
in {
  options.modules.gaming.enable = lib.mkEnableOption "gaming";

  # My system-level config installs steam, but Home Manager is being used standalone and I don't want to make it a system module at the moment.
  # This introduces the possibility that Steam and the other gaming programs used herein are not actually installed.
  # It's a minor risk considering I'm the only maintainer of this config, so it's one I'm willing to accept.
  # If I choose to make Home Manager a module in the future, the osConfig argument that it will begin passing will have the packages that the below config assumes exist.
  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = primaryMonitor != null;
        message = "gaming requires exactly one monitor with primary = true in modules.host.monitors";
      }
    ];

    home.packages = with pkgs; [
      gamescoperun
      pkgs.gamescope
      pkgs.lutris
      steam-gamescope
      heroic-gamescope
      heroic
      steam
      discord
      cockatrice
    ];
    xdg.desktopEntries = {
      steamGamescope = {
        name = "Steam (Gamescope)";
        exec = "${steam-gamescope}/bin/steam-gamescope";
        icon = "steam";
        type = "Application";
        terminal = false;
        categories = ["Game"];
        mimeType = [
          "x-scheme-handler/steam"
          "x-scheme-handler/steamlink"
        ];
        settings = {
          StartupNotify = "true";
          StartupWMClass = "Steam";
          PrefersNonDefaultGPU = "true";
          X-KDE-RunOnDiscreteGpu = "true";
          Keywords = "gaming";
        };
        actions = {
          client = {
            name = "Steam";
            exec = "steam";
          };
        };
      };

      steam = {
        name = "Steam";
        exec = "${steam}/bin/steam";
        icon = "steam";
        type = "Application";
        terminal = false;
        categories = ["Game"];
        mimeType = [
          "x-scheme-handler/steam"
          "x-scheme-handler/steamlink"
        ];
        settings = {
          StartupNotify = "true";
          StartupWMClass = "Steam";
          PrefersNonDefaultGPU = "true";
          X-KDE-RunOnDiscreteGpu = "true";
          Keywords = "gaming";
        };
      };

      heroicGamescope = {
        name = "Heroic (Gamescope)";
        exec = "${heroic-gamescope}/bin/heroic-gamescope";
        icon = "com.heroicgameslauncher.hgl";
        type = "Application";
        categories = ["Game"];
        actions = {
          client = {
            name = "Heroic";
            exec = "heroic";
          };
        };
      };
      "com.heroicgameslauncher.hgl" = {
        name = "Heroic";
        exec = "${heroic}/bin/heroic-launcher";
        icon = "com.heroicgameslauncher.hgl";
        type = "Application";
        categories = ["Game"];
        actions = {
          client = {
            name = "Heroic";
            exec = "heroic";
          };
        };
      };
    };
  };
}
