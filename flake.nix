{
    description = "My Nixos Configurations";

    inputs = {
        nixpkgs.url = "nixpkgs/nixos-24.05";
        nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";
        nur.url = "github:nix-community/NUR";
        home-manager = {
            url = "github:nix-community/home-manager/release-24.05";
            inputs.nixpkgs.follows = "nixpkgs";
        };
        xdph.url = "github:hyprwm/xdg-desktop-portal-hyprland";
        nixvim = {
            url = "github:m-macdonald/nixvim-flake";
            inputs.nixpkgs.follows = "nixpkgs-unstable";
        };
        sops-nix = {
            url = "github:Mic92/sops-nix";
            inputs.nixpkgs.follows = "nixpkgs";
        };
    };

    outputs = { nixpkgs, nixpkgs-unstable, home-manager, nur, sops-nix, ... }@inputs : 
        let
            volta-package = ./packages/volta.nix;
            flameshot-package = ./packages/flameshot.nix;
            swww-package = ./packages/swww.nix;

            overlays = [ 
                overlay-unstable
                overlay-volta
                #      import ./overlays/flameshot
                overlay-flameshot
                overlay-swww
            ];

            system = "x86_64-linux";

            utils = import ./utils {
                inherit system nixpkgs pkgs home-manager lib overlays /* patchedPkgs */inputs;
            };

            pkgs = import nixpkgs {
                inherit system;
                config = { 
                    allowUnfree = true;
                    packageOverrides = pkgs: {
                        steam = override-steam pkgs;
                        nur = override-nur pkgs;
                    };
                };
                overlays = overlays;
            };

            overlay-unstable = final: prev: {
                unstable = import nixpkgs-unstable {
                    inherit system;
                    config.allowUnfree = true;
                };
            };

            overlay-volta = final: prev: {
                volta = prev.callPackage volta-package {};
            };

            overlay-flameshot = final: prev: {
                flameshot = prev.callPackage flameshot-package {};
            };

            overlay-swww = final: prev: {
                swww = prev.callPackage swww-package {};
            };

            override-steam = pkgs: 
                pkgs.steam.override {
                    extraPkgs = pkgs: with pkgs; [
                        xorg.libXcursor
                        xorg.libXi
                        xorg.libXinerama
                        xorg.libXScrnSaver
                        libpng
                        libpulseaudio
                        libvorbis
                        stdenv.cc.cc.lib
                        libkrb5
                        keyutils
                    ];
                };

            override-nur = pkgs:
                import nur { 
                    nurpkgs = nixpkgs.legacyPackages.x86_64-linux;
                    pkgs = nixpkgs.legacyPackages.x86_64-linux;
                };

            lib = nixpkgs.lib;

            mkSystem = folder: hostname:
                let
                    system = import ./${folder}/${hostname}/_localSystem.nix; 
                in lib.nixosSystem
                {
                    inherit system; 

                    modules = [
                        sops-nix.nixosModules.sops
                        { networking.hostName = hostname; }
                        (./. + "/hosts/${hostname}/system-configuration.nix")
                        (./. + "/hosts/${hostname}/hardware-configuration.nix")
                        ({config, ...}: {
                            sops = {
                                defaultSopsFile = ./secrets/secrets.yaml;
                                age = {
                                    sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
                                    keyFile = "/var/lib/sops-nix/key.txt";
                                    generateKey = true;
                                };
                                secrets."users/maddux/password" = {
                                        neededForUsers = true;
                                };
                            };
                            users = {
                                mutableUsers = false;
                                users = builtins.listToAttrs (
                                    map
                                    (username:
                                        let userFolder = "${folder}/${hostname}/users/${username}";
                                        in
                                            {
                                            name = username;
                                            value = utils.user.mkSystemUser  ({inherit username config;} // (import ./${userFolder}/system.nix { inherit pkgs inputs; }));
                                        }
                                    )
                                    (utils.lsLib.ls ./${folder}/${hostname}/users)
                                );
                            };
                        })
                    ];
                    specialArgs = { inherit inputs pkgs; };
                };

            mkUsers = folder: hostname:
                builtins.listToAttrs
                (
                    map 
                    (username: 
                        let 
                            userFolder = "${folder}/${hostname}/users/${username}";
                        in
                            {
                            name = "${username}@${hostname}";
                            value = utils.user.mkHmUser {
                                username = username;
                                userConfig = ./${userFolder}/home.nix;
                            };
                        })
                    (utils.lsLib.ls ./${folder}/${hostname}/users)
                );
        in {

            homeManagerConfigurations = (folder:
                utils.attrsets.recursiveMerge (
                    builtins.map 
                    (hostname: mkUsers folder hostname)
                    (utils.lsLib.ls ./${folder})
                )
            ) "hosts";

            nixosConfigurations = (folder: 
                builtins.listToAttrs 
                (
                    map
                    (hostname: {
                        name = hostname;
                        value = mkSystem folder hostname;
                    })
                    (utils.lsLib.ls ./${folder})
                )) "hosts";
        };
}
