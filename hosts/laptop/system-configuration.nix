{ config, pkgs, inputs, ... }:
{
    imports = [
        ../../modules/nixos
    ];

    config = {

        modules = {
            docker.enable = true;
            hyprland.enable = true;
            bluetooth.enable = true;
        };

        environment.variables = {
            NIXOS_OZONE_WL = "1";
            __GL_GSYNC_ALLOWED = "0";
            __GL_VRR_ALLOWED = "0";
            _JAVA_AWT_WM_NONREPARENTING = "1";
            DISABLE_QT5_COMPAT = "0";
            GDK_BACKEND = "wayland";
            ANKI_WAYLAND = "1";
            WLR_DRM_NO_ATOMIC = "1";
            QT_AUTO_SCREEN_SCALE_FACTOR = "1";
            # Setting this to x11 to fix flameshot issues
            QT_QPA_PLATFORM = "x11";
            QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
            MOZ_ENABLE_WAYLAND = "1";
            # WLR_BACKEND = "vulkan";
            # WLR_RENDERER = "vulkan";
            XDG_SESSION_TYPE = "wayland";
            # This variable seems to conflict with gamescope. Commenting for testing
            #    SDL_VIDEODRIVER = "wayland";
            CLUTTER_BACKEND = "wayland";
        };

        hardware = {
            opengl = {
                enable = true;
                driSupport = true;
                driSupport32Bit = true;
            };
        };

        boot = {
            loader = {
                systemd-boot.enable = true;
                efi.canTouchEfiVariables = true;
            };
            tmp.cleanOnBoot = true;
        };

        systemd.enableEmergencyMode = false;

        services.xserver = {
            layout = "dh,us";
            extraLayouts.dh = {
                description = "Colemak-DH ergo";
                languages = [ "eng" ];
                symbolsFile = symbols/colemak_dh;
            };
        };

        time.timeZone = "America/New_York";
        i18n.defaultLocale = "en_US.UTF-8";
        console = {
            keyMap = "us";
        };

        programs = {
            dconf.enable = true;
            xwayland.enable = true;
        };
        security.polkit.enable = true;

        security.rtkit.enable = true;

        # DO NOT EDIT
        system.stateVersion = "23.11";
    };
}
