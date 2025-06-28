{ inputs, pkgs, lib, config, ... }:

with lib;
let cfg = config.modules.hyprland;

in {
    options.modules.hyprland= { enable = mkEnableOption "hyprland"; };
    config = mkIf cfg.enable {
	home.packages = with pkgs; [
	    wofi swaybg wlsunset wl-clipboard hyprland 
	];

        home.file.".config/hypr/hyprland.conf".source = ./hyprland.conf;

    gtk = {
        enable = true;
        theme = {
            name = "Adwaita-dark";  # or your theme name
            package = pkgs.gnome-themes-extra;  # or another package like `catppuccin-gtk`
        };
        iconTheme = {
            name = "Adwaita";  # or Papirus, etc.
            package = pkgs.adwaita-icon-theme;
        };
        cursorTheme = {
            name = "Adwaita";
            package = pkgs.adwaita-icon-theme;
            size = 24;
        };
    };

    };
}
