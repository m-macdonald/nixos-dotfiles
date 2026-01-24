{ config, pkgs, lib, inputs, ... }:
with lib;
let
	cfg = config.modules.mkv;
	modifiedMkv = pkgs.makemkv.overrideAttrs (prev: {
			preFixup = (prev.preFixup or "") + ''
				cp $out/lib/libmmbd.so.0 $out/lib/libaacs.so.0
				cp $out/lib/libmmbd.so.0 $out/lib/libbdplus.so.0
			'';
		});
	libblurayBroke = (pkgs.libbluray.override {
		withAACS = true;
		withBDplus = true;
		withJava = true;
    });
		# libaacs = modifiedMkv;
		# libbdplus = modifiedMkv;
		# libaacs = pkgs.libaacs.overrideAttrs (accsPrev: {
            # nativeBuildInputs = with pkgs; [makemkv] ++ (prev.nativeBuildInputs or []);
            # buildInputs = (accsPrev.buildInputs or []) ++ [pkgs.makemkv];
            # postInstall = (accsPrev.postInstall or "") + ''
            #     patchelf --add-rpath "${pkgs.makemkv}/lib" $out/lib/libaacs.so
            # '';
			# preFixup = (prev.preFixup or "") + ''
			# 	cp ${pkgs.makemkv}/lib/libmmbd.so.0 $out/lib/libaacs.so.0
			# '';
   #          doCheck = false;
   #          doInstallCheck = false;
   #          dontCheck = true;
                # rm $out/lib/libaacs.so.*
                # ln -s ${pkgs.makemkv}/lib/libmmbd.so.0 $out/lib/libaacs.so.0
            # postFixup = (prev.postFixup or "") + ''
            #     rm $out/lib/libaacs.so.0
            #     ln -s ${pkgs.makemkv}/lib/libmmbd.so.0 $out/lib/libaacs.so.0
            # '';
		# });
		# libbdplus = pkgs.libbdplus.overrideAttrs (bdPlusPrev: {
            # nativeBuildInputs = with pkgs; [makemkv] ++ (prev.nativeBuildInputs or []);
            # buildInputs = (bdPlusPrev.buildInputs or []) ++ [pkgs.makemkv];
            # postInstall = (bdPlusPrev.postInstall or "") + ''
            #     patchelf --add-rpath "${pkgs.makemkv}/lib/" $out/lib/libbdplus.so
            # '';
			# preFixup = (prev.preFixup or "") + ''
			# 	cp ${pkgs.makemkv}/lib/libmmbd.so.0 $out/lib/libbdplus.so.0
			# '';
			#
            # postFixup = (prev.postFixup or "") + ''
            #     rm $out/lib/libbdplus.so.0
            #     ln -s ${pkgs.makemkv}/lib/libmmbd.so.0 $out/lib/libbdplus.so.0
            # '';
   #          doCheck = false;
   #          doInstallCheck = false;
   #          dontCheck = true;
	# 	});
	# }).overrideAttrs (prev: {
        # buildInputs = (prev.buildInputs or []) ++ [pkgs.makemkv];
        # postInstall = (prev.postInstall or "") + ''
        #     patchelf --add-rpath "${pkgs.makemkv}/lib/" $out/lib/libbluray.so
        # '';
    # });
    # wrappedVlc = pkgs.symlinkJoin {
    #     name = "vlc-mmbd";
    #     paths = [ pkgs.vlc ];
    #     buildInputs = [ pkgs.makeWrapper ];
    #     postBuild = ''
    #         wrapProgram $out/bin/vlc \
    #             --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath [
    #                 pkgs.libbluray
    #                 pkgs.libaacs
    #                 pkgs.libbdplus
    #                 pkgs.makemkv
    #             ]}"
    #     '';
    # };
	vlc = (pkgs.vlc.override { libbluray = libblurayBroke; });
    #         .overrideAttrs(prev: { 
    #     # doCheck = false;
    #     # doInstallCheck = false;
    #     # dontCheck = true;
    #     # postFixup = (prev.postFixup or "") + ''
    #     #     ln -s ${pkgs.makemkv}/lib/libmmbd.so.0 $out/lib
    #     # '';
    # });
in {
	options.modules.mkv = {
		enable = mkEnableOption "disk ripping";
	};

	config = mkIf cfg.enable {
		home.packages = with pkgs; [
			mkvtoolnix
			makemkv
			mpv
            # TODO: I don't particularly want Java exposed to my entire user environment, but I'm too lazy to go a different route right now
            jdk17
		] ++ [ vlc ];
/*
		home.file = {
			".nix-profile/lib/libbdplus.so.0".source = "${pkgs.makemkv}/lib/libmmbd.so.0";
			".nix-profile/lib/libaacs.so.0".source = "${pkgs.makemkv}/lib/libmmbd.so.0";
		};
		*/
	};

/*
	imports = [
		inputs.arion.nixosModules.arion
	];


	options.modules.mkv = {
		enable = mkEnableOption "disk ripping";
	};

	config = mkIf cfg.enable {
		virtualisation.arion = {
			backend = "podman-socket";
			projects.mkv = {
				serviceName = "mkv";
				settings = {
					services = {
						makemkv.service = {
							image = "jlesage/makemkv:v24.12.1";
							volumes = [
								"/data/makemkv/output:/output:rw"	
								"/home/maddux/makemkv/config:/config:rw"
							];
							devices = [
								"/dev/sr0:/dev/sr0"
								"/dev/sg2:/dev/sg2"
							];
							ports = [
								"5800:5800"
							];
						};
					};	
				};
			};
		};
	};
*/
}
