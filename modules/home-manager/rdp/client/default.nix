{lib, config, ...} :
with lib;
let
cfg = config.modules.rdp.client;
in {
  options.modules.rdp.client = { 
    enable = mkEnableOption "Remmina RDP Client";
  };
   
    config = mkIf cfg.enable {
        services.remmina = {
            enable = true;
        };
    };
}
