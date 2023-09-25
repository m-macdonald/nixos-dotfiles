{  config, lib, inputs, ... }: 
with lib;
let 
  cfg = config.modules.docker;
in
{
  options.modules.docker = {
    enable = mkOption {
      description = "Enable Docker";
      type = types.bool;
      default = false;
    };
  };

  config = mkIf cfg.enable {
    virtualisation.docker.enable = true;
  };
}
