{ config, pkgs, inputs, ... }:
let
  nvidia-offload = pkgs.writeShellScriptBin "nvidia-offload" ''
    export __NV_PRIME_RENDER_OFFLOAD=1
    export __NV_PRIME_RENDER_OFFLOAD_PROVIDER=NVIDIA-GO
    export __GLX_VENDOR_LIBRARY_NAME=nvidia
    export __VK_LAYER_NV_optimus=NVIDIA_only
    exec -a "$0" "$@"
  '';
in
{
  imports = [
    ../../modules/network-shares
  ];
  nixpkgs.config.packageOverrides = pkgs: {
    linuxPackages_latest = pkgs.unstable.linuxPackages_latest;
    nvidia_x11 = pkgs.unstable.nvidia_x11;
  };

  environment.defaultPackages = [];

  programs.zsh.enable = true;

  fonts = {
    fonts = with pkgs; [
      roboto
      nerdfonts
    ];

    fontconfig = {
      hinting.autohint = true;
    };
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
    QT_QPA_PLATFORM = "wayland";
    QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
    MOZ_ENABLE_WAYLAND = "1";
    WLR_BACKEND = "vulkan";
    WLR_RENDERER = "vulkan";
    WLR_NO_HARDWARE_CURSORS = "1";
    XDG_SESSION_TYPE = "wayland";
    XDG_CURRENT_DESKTOP = "Hyprland";
    XDG_SESSION_DESKTOP = "Hyprland";
    # This variable seems to conflict with gamescope. Commenting for testing
#    SDL_VIDEODRIVER = "wayland";
    CLUTTER_BACKEND = "wayland";
  };

  xdg = {
    portal = {
      enable = true;
      wlr.enable = true;
      extraPortals = with pkgs; [
        inputs.xdph
      ];
    };
  };


  environment.systemPackages = with pkgs; [
    vulkan-loader
    vulkan-validation-layers
    vulkan-tools
    wpa_supplicant
    # Pulls in lspci, which Hyprland seems to need in order to function.
    # It's unclear to me why it works on my desktop without pciutils
    pciutils

    nvidia-offload
  ];

  hardware = {
    pulseaudio.enable = false;
    bluetooth.enable = false;
    opengl = {
      enable = true;
      driSupport = true;
      driSupport32Bit = true;
      extraPackages = with pkgs; [
        nvidia-vaapi-driver
#       amdvlk
#       vaapiVdpau
      ];
    };
/*
    nvidia = {
      open = true;
      nvidiaPersistenced = true;
      package = config.boot.kernelPackages.nvidiaPackages.latest;
      powerManagement.enable = true;
      modesetting.enable = true;
      prime = {
        offload = {
          enable = true;
#          enableOffloadCmd = true;
        };
        amdgpuBusId = "PCI:6:0:0";
        nvidiaBusId = "PCI:1:0:0";
        };
        };
        */
  };
  nix = {
    settings = {
      auto-optimise-store = true;
      allowed-users = [ "maddux" ];
      substituters = ["https://hyprland.cachix.org"];
      trusted-public-keys = ["hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="];
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
    extraOptions = "
      experimental-features = nix-command flakes
      keep-outputs = true
      keep-derivations = true
    ";
  };

  boot = {
#    kernelParams = [ "module_blacklist=amdgpu" ];
    blacklistedKernelModules = [ "nvidiafb" "nouveau" ];
#    kernelPackages = pkgs.unstable.linuxPackages_latest;
    kernelModules = [ "kvm-amd" "amdgpu" ];
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    cleanTmpDir = false;
#    extraModulePackages = [ config.boot.kernelPackages.rtw89 ];
  };

  time.timeZone = "America/New_York";
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    keyMap = "us";
  };

  users.users.maddux = {
    isNormalUser = true;
    extraGroups = [ "input" "wheel" ];
    shell = pkgs.zsh;
    initialPassword = "changeme";
  };
/*
  security = {
    sudo.enable = false;
    doas = {
      enable = true;
      extraRules = [{
        users = [ "maddux" ];
        keepEnv = true;
        persist = true;
      }];
    };
  };
  */

  programs.sway.enable = true;

  sound = {
    enable = true;
#    mediaKeys = true;
  };

  networking.wireless = {
    enable = true;
    userControlled.enable = true;
    networks = {
      "1101" = {
        pskRaw = "5cc04f7877e0c038c837996079aa9bf76f612770fdc3511425e2f37913df8af9";
      };
      "MiFibra-6B57" = {
        pskRaw = "9b58b80d89aae462a1a35d83af97346c29f9d3a1ce8ee8cdfbfcd48c67ead8f3";
      };
    };
  };

  security.rtkit.enable = true;
  services = {
    pipewire = {
      enable = true;
      alsa = {
        enable = true;
        support32Bit = true;
      };
      wireplumber.enable = true;
      pulse.enable = true;
      jack.enable = true;
    };
    logind.lidSwitch = "suspend";
    tlp = {
      enable = true;
      settings = {
        START_CHARGE_THRESH_BAT0 = 0; # Dummy value
        STOP_CHARGE_THRESH_BAT0 = 1; # Battery conservation mode
        CPU_BOOST_ON_AC = 1;
        CPU_BOOST_ON_BAT = 0;
        CPU_SCALING_GOVERNER_ON_AC = "performance";
        CPU_SCALING_GOVERNER_ON_BAT = "powersave";
      };
    };
    xserver = {
      # Symlinks the configuration to /etc/X11/xorg.conf
      exportConfiguration = true;
      desktopManager.xterm.enable = false;
      windowManager.awesome.enable = true;
      # nvidia config
      # TODO: Maybe move the Nvidia Config into its own module
      drivers = [# "modesetting" "nvidia"
        {
          name = "modesetting";
          display = true;
          deviceSection = ''
            BusID "PCI:6:0:0"
          '';
        }
        {
          name = "nvidia";
#          modules = [   ];
          display = false;
          deviceSection = ''
            BusID "PCI:1:0:0"
          '';
          screenSection = ''
            Option "RandRRotation" "on"
          '';
        }
      ];
    };
  };

  
  # DO NOT EDIT
  system.stateVersion = "22.11";
}
