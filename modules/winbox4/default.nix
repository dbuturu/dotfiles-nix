{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.modules.winbox4;
in {
  options.modules.winbox4.enable = mkEnableOption "Winbox 4";

  config = mkIf cfg.enable {
    home.packages = with pkgs; [ winbox4 ];

    # Create a shell wrapper to run Winbox using the command `winbox`
    home.file.".local/bin/winbox" = {
      executable = true;
      text = ''
        #!/bin/sh
        exec ${pkgs.winbox4}/bin/WinBox "$@"
      '';
    };

    # Ensure the custom bin directory is in PATH
    home.sessionPath = [ "$HOME/.local/bin" ];
  };
}
6