{ pkgs, lib, config, ... }:

with lib;
let cfg = config.modules.foot;

in {
    options.modules.foot = { enable = mkEnableOption "foot"; };
    config = mkIf cfg.enable {
        programs.foot = {
            enable = true;
            settings = {
                main = {
                    font = "JetBrainsMono Nerdfont:size=7";
                    pad = "12x12";
                    key-bindings = [
                        {
                            key = "Alt+v";
                            action = "paste";
                        }
                        {
                            key = "Alt+c";
                            action = "copy";
                        }
                    ];
                };
            };
        };
    };
}
