{ config, lib, pkgs, inputs, ... }:
with lib;
let
cfg = config.modules.games;
in {
    options.modules.games = { enable = mkEnableOption "games"; };

    imports = [
        inputs.play-nix.homeManagerModules.play
    ];

    # My system-level config installs steam, but Home Manager is being used standalone and I don't want to make it a system module at the moment.
    # This introduces the possibility that Steam and the other gaming programs used herein are not actually installed.
    # It's a minor risk considering I'm the only maintainer of this config, so it's one I'm willing to accept.
    # If I choose to make Home Manager a module in the future, the osConfig argument that it will begin passing will have the packages that the below config assumes exist.
    config = mkIf cfg.enable {
        play = {
            monitors = [
                {
                    name = "DP-1";
                    primary = true;
                    width = 2560;
                    height = 1440;
                    refreshRate = 144;
                    vrr = true;
                }
                {
                    name = "DP-2";
                    primary = false;
                    width = 1920;
                    height = 1080;
                    refreshRate = 144;
                }
            ];

            gamescoperun = {
                enable = true;

                defaultHDR = false;
                defaultWSI = true;
                defaultSystemd = false;

                # extraOptions = {
                #     "expose-wayland" = true;
                # };

                baseOptions = {
                    # "fsr-upscaling" = true;
                    # Overrides monitor derived-width
                    # "output-width" = 2560;
                };
            };

            wrappers = {
                steam = lib.mkDefault {
                    enable = true;

                    # command = "steam -bigpicture -tenfoot";
                    command = "/run/current-system/sw/bin/steam -bigpicture -tenfoot";
                    # package = pkgs.steam;

                    useWSI = false;

                    extraOptions = {
                        "steam" = true;
                    };

                    environment = {
                        STEAM_FORCE_DESKTOPUI_SCALING = 1;
                        STEAM_GAMEPADUI = 1;
                    };
                };

                heroic = lib.mkDefault {
                    enable = true;

                    package = pkgs.heroic;
                };
    
                # # This wrapper is unused at the moment
                # lutris = lib.mkDefault {
                #     enable = true;
                #
                #     command = "lutris";
                #
                #     extraOptions = {
                #         "force-windows-fullscreen" = true;
                #         "expose-wayland" = true;
                #     };
                #
                #     environment = {
                #         LUTRIS_SKIP_INIT = 1;
                #     };
                # };
            };
        }; 

        xdg.desktopEntries = {
            steam = lib.mkDefault {
                name = "Steam (Gamescope)";
                exec = "${lib.getExe config.play.wrappers.steam.wrappedPackage}";
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

            heroic = lib.mkDefault {
                name = "Heroic (Gamescope)";
                exec = "${lib.getExe config.play.wrappers.heroic.wrappedPackage}";
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

            "net.lutris.Lutris" = lib.mkDefault {
                name = "Lutris";
                comment = "Video game preservation platform";
                exec = "/run/current-system/sw/bin/lutris %U";
                icon = "net.lutris.Lutris";
                type = "Application";
                terminal = false;
                categories = ["Game"];
                mimeType = ["x-scheme-handler/lutris"];
                settings = {
                    StartupNotify = "true";
                    StartupWMClass = "Lutris";
                    Keywords = "gaming;wine;emulator;";
                };
            };
        };

        home.packages = with pkgs; [
            # steam
            # heroic
            # bottles
            
            # xivlauncher
    	    discord
            cockatrice
        ];
    };
}
