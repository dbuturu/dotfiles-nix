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
  };
}