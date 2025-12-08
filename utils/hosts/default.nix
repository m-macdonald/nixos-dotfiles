{ lib, ... }: 
{
    options.modules.host.monitors = lib.mkOption {
        type = lib.types.listOf (
            lib.types.submodule {
                options = {
                    name = lib.mkOption {
                        description = "Name of the monitor";
                        type = lib.types.str; 
                    };
                    mode = lib.mkOption {
                        type = lib.types.submodule {
                            options = {
                                height = lib.mkOption {
                                    description = "Monitor height";
                                    type = lib.types.ints.unsigned;
                                    default = 0;
                                };
                                width = lib.mkOption {
                                    description = "Monitor width";
                                    type = lib.types.ints.unsigned;
                                    default = 0;
                                };
                                refreshRate = lib.mkOption {
                                    description = "Monitor refresh rate";
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
                                    description = "Monitor x position relative to other monitors";
                                    type = lib.types.ints.unsigned;
                                    default = 0;
                                };
                                y = lib.mkOption {
                                    description = "Monitor y position relative to other monitors";
                                    type = lib.types.ints.unsigned;
                                    default = 0;
                                };
                            };
                        };
                    };
                };
            }
        );
    };
}
