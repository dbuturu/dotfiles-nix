{ pkgs, lib, config, ... }:

with lib;
let cfg = config.modules.xremap;

in {
    options.modules.xremap = { enable = mkEnableOption "xremap;"; };
    config = mkIf cfg.enable {
        services.xremap = {
            userName = "dbuturu";
            withHypr = true;
            config = {
                keymap = [
                {
  	                name = "main";
                    remap = {
                        "CAPSLOCK" = "ESC";
  	                };
  	            }
                ];
            };
        };
    };
}
