{ pkgs, lib, config, ... }:

with lib;
let
  cfg = config.modules.ghostty;
in
{
  options.modules.ghostty = {
    enable = mkEnableOption "Ghostty terminal emulator";
  };

  config = mkIf cfg.enable {
    home.packages = [ pkgs.ghostty ];

    home.file.".config/ghostty/config".text = 
    ''
      
      font-family = "Fira Code Nerdfont"
      font-size = 10
      # Keybinds to match macOS since this is a VM
      keybind = alt+c=copy_to_clipboard
      keybind = alt+v=paste_from_clipboard
      keybind = alt+minus=decrease_font_size:1
      keybind = alt+zero=reset_font_size
      keybind = ctrl+q=quit
      keybind = alt+shift+comma=reload_config
      keybind = ctrl+l=clear_screen
      keybind = alt+n=new_window
      keybind = alt+w=close_surface
      keybind = alt+shift+w=close_window
      keybind = alt+t=new_tab
      keybind = alt+h=previous_tab
      keybind = alt+l=next_tab
      keybind = alt+shift+l=new_split:right
      keybind = alt+shift+j=new_split:down
      keybind = alt+j=goto_split:next
      keybind = alt+k=goto_split:previous
    '';
  };
}