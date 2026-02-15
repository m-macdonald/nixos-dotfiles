{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
with lib; let
  cfg = config.modules.amd;
in {
  options.modules.amd = {
    enable = mkEnableOption "Enable AMD drivers";
  };

  config = mkIf cfg.enable {
    hardware.amdgpu = {
        overdrive.enable = true;
        opencl.enable = true;
    };


    play = {
      amd.enable = true;
      steam = {
        enable = true;
        extraCompatPackages = with pkgs; [
          proton-ge-bin
          inputs.dw-proton.packages.${pkgs.stdenv.hostPlatform.system}.default
        ];
      };
      gamemode.enable = true;
      lutris.enable = true;
    };

    systemd.tmpfiles.rules = let
      rocmEnv = pkgs.symlinkJoin {
        name = "rocm-combined";
        paths = with pkgs.rocmPackages; [
          rocblas
          hipblas
          clr
        ];
      };
    in [
      "L+    /opt/rocm   -    -    -     -    ${rocmEnv}"
    ];
  };
}
