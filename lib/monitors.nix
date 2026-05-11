{
  lib,
  config,
  ...
}: {
  options.modules.host.monitors = lib.mkOption {
    type = lib.types.listOf (
      lib.types.submodule {
        options = {
          name = lib.mkOption {
            description = "name of the monitor";
            type = lib.types.str;
          };
          mode = lib.mkOption {
            type = lib.types.submodule {
              options = {
                height = lib.mkOption {
                  description = "monitor height";
                  type = lib.types.ints.unsigned;
                  default = 0;
                };
                width = lib.mkOption {
                  description = "monitor width";
                  type = lib.types.ints.unsigned;
                  default = 0;
                };
                refreshRate = lib.mkOption {
                  description = "monitor refresh rate";
                  type = lib.types.addCheck lib.types.float (x: x > 0);
                  default = 59.99;
                };
              };
            };
          };
          position = lib.mkOption {
            type = lib.types.submodule {
              options = {
                x = lib.mkOption {
                  description = "monitor x position relative to other monitors";
                  type = lib.types.ints.unsigned;
                  default = 0;
                };
                y = lib.mkOption {
                  description = "monitor y position relative to other monitors";
                  type = lib.types.ints.unsigned;
                  default = 0;
                };
              };
            };
          };
          primary = lib.mkOption {
            type = lib.types.bool;
            default = false;
            description = "Whether this is the primary monitor";
          };
        };
      }
    );
  };

  config = {
    assertions = let
      primaryMonitorCnt = lib.length (lib.filter (m: m.primary) config.modules.host.monitors);
    in [
      {
        assertion = primaryMonitorCnt == 1;
        message = "modules.host.monitors requires exactly one primary monitor, found ${toString primaryMonitorCnt}";
      }
    ];
  };
}
