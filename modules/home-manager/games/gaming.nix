{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.gaming;

  primaryMonitor = lib.findFirst (m: m.primary) null config.modules.host.monitors;

  toCliArgs = attrs:
    lib.concatStringsSep " " (
      lib.mapAttrsToList (
        name: value:
          if value == true
          then "--${name}"
          else if value == false
          then ""
          else "--${name} ${toString value}"
      )
      attrs
    );

  baseOptions =
    {
      backend = "sdl";
      fade-out-duration = 200;
      fullscreen = true;
      immediate-flips = true;
      nested-refresh = primaryMonitor.refreshRate;
      output-height = primaryMonitor.mode.height;
      output-width = primaryMonitor.mode.width;
      rt = true;
    }
    // cfg.extraOptions;

  baseEnvironment =
    {
      AMD_VULKAN_ICD = "RADV";
      DISABLE_LAYER_AMD_SWITCHABLE_GRAPHICS_1 = "1";
      DISABLE_LAYER_NV_OPTIMUS_1 = "1";
      GAMESCOPE_WAYLAND_DISPLAY = "gamescope-0";
      PROTON_ADD_CONFIG = "sdlinput,wayland";
      PROTON_ENABLE_WAYLAND = "1";
      RADV_PERFTEST = "aco";
      SDL_VIDEODRIVER = "wayland";
    }
    // lib.optionalAttrs cfg.wsi {ENABLE_GAMESCOPE_WSI = "1";}
    // lib.optionalAttrs cfg.hdr {
      DXVK_HDR = "1";
      ENABLE_HDR_WSI = "1";
      PROTON_ENABLE_HDR = "1";
    }
    // cfg.extraEnvironment;

  hdrArgs =
    # TODO: Add check that primaryMonitor has HDR enabled?
    lib.optionalString cfg.hdr
    "--hrd-enabled --hdr-debug-force-output --hdr-debug-force-support";

  envString = lib.concatStringsSep "\n" (
    lib.mapAttrsToList (
      name: value: "export ${name}=${lib.escapeShellArg value}"
    )
    baseEnvironment
  );

  mkWrapper = name: wcfg:
    pkgs.writeShellScriptBin name ''
      ${lib.optionalString (wcfg.hdr != null)
        "export GAMESCOPE_USE_HDR=${
          if wcfg.hdr
          then "1"
          else "0"
        }"}
      ${lib.optionalString (wcfg.wsi != null)
        "export GAMESCOPE_USE_WSI=${
          if wcfg.wsi
          then "1"
          else "0"
        }"}
      ${lib.concatStringsSep "\n" (
        lib.mapAttrsToList (k: v: "export ${k}=${lib.escapeShellArg v}") wcfg.extraEnvironment
      )}
      exec ${gamescoperun}/bin/gamescoperun ${wcfg.command} "$@"
    '';

  gamescoperun = pkgs.writeShellScriptBin "gamescoperun" ''
    if [ -n "$GAMESCOPE_WAYLAND_DISPLAY" ]; then
        echo "[gamescoperun] already inside Gamescope session, running directly..."
        exec "$@"
    fi

    if [ $# -eq 0 ]; then
        echo "Usage: gamescoperun <command> [args...]"
        exit 1
    fi

    ${envString}

    exec ${lib.getExe pkgs.gamescope} \
        ${toCliArgs baseOptions} \
        ${hdrArgs} \
        "$@"
  '';
in {
  options.gaming = {
    enable = lib.mkEnableOption "gamescoperun";
    hdr = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable HDR";
    };
    wsi = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable WSI";
    };
    extraOptions = lib.mkOption {
      type = with lib.types; attrsOf (oneOf [str int bool]);
      default = {};
      description = "Additional gamescope CLI options";
    };
    extraEnvironment = lib.mkOption {
      type = with lib.types; attrsOf str;
      default = {};
      description = "Additional environment variables";
    };
    wrappers = lib.mkOption {
      default = {};
      description = "Per-application gameescope wrappers";
      type = lib.types.attrsOf (lib.types.submodule {
        options = {
          enable = lib.mkEnableOption "this wrapper";
          command = lib.mkOption {
            type = lib.types.str;
            description = "Command to run inside gamescope";
          };
        };
      });
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages =
      [
        gamescoperun
        pkgs.gamescope
      ]
      ++ lib.mapAttrsToList mkWrapper (
        lib.filterAttrs (_: w: w.enable) cfg.wrappers
      );
  };

  gaming = {
    enable = true;
    wrappers = {
      heroic = {
        enable = true;
        command = "${pkgs.heroic}/bin/heroic";
      };
      steam = {
        enable = true;
        command = "${pkgs.steam}/bin/steam";
      };
    };
  };

  assertions = [
    {
      assertion = primaryMonitor != null;
      message = "gaming requires exactly one monitor with primary = true in modules.host.monitors";
    }
  ];
}
