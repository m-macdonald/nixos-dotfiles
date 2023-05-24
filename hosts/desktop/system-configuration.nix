{ config, pkgs, inputs, ... }:
{
  imports = [
    ../../modules/network-shares
  ];
  environment.defaultPackages = [];
  services.xserver.desktopManager.xterm.enable = false;

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
    # Setting this to x11 to fix flameshot issues
    QT_QPA_PLATFORM = "x11";
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
      extraPortals = with pkgs; [
        inputs.xdg-portal-hyprland
      ];
    };
  };

  # NVIDIA CONFIG
  # this can probably be moved to its own module
  services.xserver.videoDrivers = [ "nvidia" ];

  environment.systemPackages = with pkgs; [
    vulkan-loader
    vulkan-validation-layers
    vulkan-tools
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
      ];
    };
    nvidia = {
      open = true;
      powerManagement.enable = true;
      modesetting.enable = true;
    };
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
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    cleanTmpDir = true;
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
  sound = {
    enable = true;
#    mediaKeys = true;
  };

  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa = {
      enable = true;
      support32Bit = true;
    };
    wireplumber.enable = true;
    pulse.enable = true;
    jack.enable = true;
  };

  
  # DO NOT EDIT
  system.stateVersion = "22.11";
}
