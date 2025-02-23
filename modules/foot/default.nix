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
                    font = "JetBrainsMono Nerdfont:size=7:line-height=16px";
                    pad = "12x12";
                };
                colors = {
                    foreground = "eeead6";
                    background = "191916";
                    ## Normal/regular colors (color palette 0-7)
                    regular0="#191916";  # black
                    regular1="#b2cbe3";
                    regular2="#bdb2e3";
                    regular3="#e2b2e3";
                    regular4="#e3b2bf";
                    regular5="#e3c9b2";
                    regular6="#d7e3b2";
                    regular7="#b2e3b2";

                    bright0="393a4d"; # bright black
                    bright1="e95678"; # bright red
                    bright2="29d398";# bright green
                    bright3="efb993";# bright yellow
                    bright4="26bbd9";
                    bright5="b072d1";# bright magenta
                    bright6="59e3e3";# bright cyan
                    bright7="d9e0ee";# bright white
                };
            };
        };
    };
}
