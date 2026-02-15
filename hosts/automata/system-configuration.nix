{
  ...
}: {
  imports = [
    ../../modules/nixos
  ];

  config = {
    modules = {
      docker.enable = true;
      amd.enable = true;
      hyprland.enable = true;
      bluetooth.enable = true;
    };

    hardware = {
      graphics = {
        enable = true;
        enable32Bit = true;
      };
    };

    boot = {
      loader = {
        systemd-boot.enable = true;
        efi.canTouchEfiVariables = true;
      };
      tmp.cleanOnBoot = true;
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
    system.stateVersion = "22.11";
  };
}
