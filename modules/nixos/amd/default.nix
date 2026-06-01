{
  config,
  lib,
  pkgs,
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

    environment.systemPackages = with pkgs; [lact];

    systemd = {
      packages = with pkgs; [lact];
      services.lactd.wantedBy = ["multi-user.target"];
      tmpfiles.rules = let
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
  };
}
