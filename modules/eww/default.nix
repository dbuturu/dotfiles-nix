{ inputs, lib, config, pkgs, ... }:
with lib;
let
    cfg = config.modules.eww;
in {
    options.modules.eww = { enable = mkEnableOption "eww"; };

    config = mkIf cfg.enable {
        # theres no programs.eww.enable here because eww looks for files in .config
        # thats why we have all the home.files

        # eww package
        home.packages = with pkgs; [
            eww
            pamixer
            brightnessctl
            nerd-fonts.jetbrains-mono
        ];

        # configuration
        home.file.".config/eww/eww.scss".source = ./eww.scss;
        home.file.".config/eww/eww.yuck".source = ./eww.yuck;

        # scripts
        home.file.".config/eww/scripts/battery" = {
            source = ./scripts/battery;
            executable = true;
        };

        home.file.".config/eww/scripts/mem-ad" = {
            source = ./scripts/mem-ad;
            executable = true;
        };

        home.file.".config/eww/scripts/memory" = {
            source = ./scripts/memory;
            executable = true;
        };

        home.file.".config/eww/scripts/music_info" = {
            source = ./scripts/music_info;
            executable = true;
        };

        home.file.".config/eww/scripts/pop" = {
            source = ./scripts/pop;
            executable = true;
        };

        home.file.".config/eww/scripts/wifi" = {
            source = ./scripts/wifi;
            executable = true;
        };

        home.file.".config/eww/scripts/workspace" = {
            source = ./scripts/workspace;
            executable = true;
        };
    };
}
